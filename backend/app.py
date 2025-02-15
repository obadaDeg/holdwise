from flask import Flask, request, jsonify, send_from_directory
import os
from werkzeug.utils import secure_filename
from datetime import datetime
import firebase_admin
from firebase_admin import auth, credentials
from cryptography.fernet import Fernet

app = Flask(__name__)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Configure the base upload folder and ensure it exists.
BASE_UPLOAD_FOLDER = 'uploads'
if not os.path.exists(BASE_UPLOAD_FOLDER):
    os.makedirs(BASE_UPLOAD_FOLDER)
app.config["UPLOAD_FOLDER"] = BASE_UPLOAD_FOLDER

# Setup Fernet encryption.
# In production, set this key via an environment variable.
FERNET_KEY = b'Ff6lqL9z6IZ_Qa1CDhPJxi0IcL4co8WXhw4Xn1Ytq9M='  # Must be 32 url-safe base64-encoded bytes.
fernet = Fernet(FERNET_KEY)

@app.route("/updateProfile", methods=["POST"])
def update_profile():
    """
    Expects a JSON payload with:
      - uid: The Firebase user ID.
      - name: The user's name.
      - phoneNumber: The user's phone number.
      - about: A short description or bio.
    """
    data = request.get_json()
    uid = data.get("uid")
    name = data.get("name")
    phone_number = data.get("phoneNumber")
    about = data.get("about")

    if not uid:
        return jsonify({"error": "Missing user uid"}), 400

    try:
        # Retrieve the current user record.
        user = auth.get_user(uid)
        current_claims = user.custom_claims if user.custom_claims else {}
        current_claims.update(
            {"name": name, "phoneNumber": phone_number, "about": about}
        )
        auth.set_custom_user_claims(uid, current_claims)

        return jsonify({"message": "Profile updated successfully."}), 200

    except Exception as e:
        return jsonify({"error": f"Error updating profile: {str(e)}"}), 500

@app.route("/upload", methods=["POST"])
def upload_file():
    """
    Expects a multipart/form-data POST request with:
      - file: The file to upload.
      - uid: The Firebase user ID (used to organize files per specialist)
    
    Returns a JSON response with an encrypted token representing the file path.
    """
    if "file" not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    # Retrieve the uid (or default to "anonymous").
    uid = request.form.get("uid", "anonymous")
    specialist_folder = os.path.join(app.config["UPLOAD_FOLDER"], uid)
    os.makedirs(specialist_folder, exist_ok=True)

    # Create a unique filename using uid and a timestamp.
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    filename = f"{uid}_{timestamp}_{secure_filename(file.filename)}"
    file_path = os.path.join(specialist_folder, filename)
    
    try:
        file.save(file_path)
    except Exception as e:
        return jsonify({"error": f"Failed to save file: {str(e)}"}), 500

    # Build the relative path (firepath) that identifies the file.
    relative_path = f"{uid}/{filename}"
    # Encrypt the relative file path.
    encrypted_token = fernet.encrypt(relative_path.encode()).decode()
    
    # Return the encrypted token.
    return jsonify({"encrypted_url": encrypted_token}), 200

@app.route("/file/<token>", methods=["GET"])
def serve_encrypted_file(token):
    """
    Expects an encrypted token in the URL. Decrypts it to determine
    the file's relative path and serves the file.
    """
    try:
        # Decrypt the token to retrieve the relative file path (e.g. "uid/filename").
        decrypted = fernet.decrypt(token.encode()).decode()
        uid, filename = decrypted.split('/', 1)
    except Exception as e:
        return jsonify({"error": f"Invalid token: {str(e)}"}), 400

    directory = os.path.join(app.config["UPLOAD_FOLDER"], uid)
    return send_from_directory(directory, filename)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

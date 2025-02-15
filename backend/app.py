from flask import Flask, request, jsonify, send_from_directory
import os
from werkzeug.utils import secure_filename
from datetime import datetime
import firebase_admin
from firebase_admin import auth, credentials

app = Flask(__name__)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Configure the base upload folder and ensure it exists.
BASE_UPLOAD_FOLDER = 'uploads'
if not os.path.exists(BASE_UPLOAD_FOLDER):
    os.makedirs(BASE_UPLOAD_FOLDER)
app.config["UPLOAD_FOLDER"] = BASE_UPLOAD_FOLDER

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
    
    Returns a JSON response with a URL for retrieving the file.
    """
    if "file" not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    uid = request.form.get("uid", "anonymous")
    specialist_folder = os.path.join(app.config["UPLOAD_FOLDER"], uid)
    os.makedirs(specialist_folder, exist_ok=True)

    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    filename = f"{uid}_{timestamp}_{secure_filename(file.filename)}"
    file_path = os.path.join(specialist_folder, filename)
    
    try:
        file.save(file_path)
    except Exception as e:
        return jsonify({"error": f"Failed to save file: {str(e)}"}), 500

    file_url = f"{request.host_url}files/{uid}/{filename}"
    return jsonify({"url": file_url}), 200

@app.route("/files/<uid>/<filename>", methods=["GET"])
def get_file(uid, filename):
    """
    Serves the file stored on the server for a specific specialist.
    """
    directory = os.path.join(app.config["UPLOAD_FOLDER"], uid)
    return send_from_directory(directory, filename)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

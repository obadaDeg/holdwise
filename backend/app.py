from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import auth, credentials


app = Flask(__name__)

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

@app.route('/updateProfile', methods=['POST'])
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
        # Optionally, retrieve the current user record.
        user = auth.get_user(uid)
        
        # Get existing custom claims if available. Otherwise, start with an empty dictionary.
        current_claims = user.custom_claims if user.custom_claims else {}

        # Update the custom claims with the new profile information.
        # **Warning:** This will replace any existing custom claims if they share the same keys.
        current_claims.update({
            "name": name,
            "phoneNumber": phone_number,
            "about": about
        })

        # Set the new custom claims for the user.
        auth.set_custom_user_claims(uid, current_claims)
        
        return jsonify({"message": "Profile updated successfully."}), 200

    except Exception as e:
        # Log the error as needed.
        return jsonify({"error": f"Error updating profile: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

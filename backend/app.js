const express = require("express");
const admin = require("firebase-admin");
const path = require("path");
const bodyParser = require("body-parser");

// Initialize your Firebase Admin SDK
const serviceAccount = require(path.join(__dirname, "serviceAccountKey.json"));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Route to set custom claims
app.post("/setCustomClaims", async (req, res) => {
  const { uid } = req.body;
  console.log(uid, 'setting custom claims');
  if (!uid) {
    return res.status(400).send({ error: "UID is required." });
  }

  try {
    await admin.auth().setCustomUserClaims(uid, { role: "patient" });
    res.status(200).send({ message: "Custom claims set successfully." });
  } catch (error) {
    console.error("Error setting custom claims:", error);
    res.status(500).send({ error: error.message });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend server is running on http://localhost:${PORT}`);
});

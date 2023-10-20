/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const axios = require("axios").default;

exports.getPlacesData = functions.https.onRequest(async (req, res) => {
  try {
    const input = req.query.input;
    const {data} = await axios.get(`https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input}&key=AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA`);
    res.status(200).json(data);
  } catch (error) {
    logger.error("Error while fetching places data:", error);
    res.status(500).send("Error fetching places data");
  }
});

import {HttpsError, onCall} from "firebase-functions/v2/https";
import {logger} from "firebase-functions/v2";
import admin from "firebase-admin";

const app = admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
export const notification = onCall({
  region: "europe-north1",
  // enforceAppCheck: true,
  // consumeAppCheckToken: true,
},
async (request) => {
  if (!request.auth) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new HttpsError("failed-precondition", "The function must be " +
      "called while authenticated.");
  }

  const appCheckToken = request.app?.token;

  if (!appCheckToken) {
    throw new HttpsError("unauthenticated", "The function must be " +
      "called with a valid AppCheck Token.");
  }


  const notificationTitle = request.data.title;
  const notificationBody = request.data.body;
  const targetDeviceFCMToken = request.data.token;

  const message = {
    notification: {
      title: notificationTitle,
      body: notificationBody,
    },
    token: targetDeviceFCMToken,
  };

  logger.log("Sending notification:", message);
  // Send a message to the device corresponding to the provided
  // registration token.
  await app.messaging().send(message)
      .then((messagingResponse) => {
        // Response is a message ID string.
        logger.log("Successfully sent message:", messagingResponse);
      })
      .catch((error) => {
        logger.log("Error sending message:", error);
        throw new HttpsError("internal", `Error sending message: ${error}`);
      });

  return {status: "ok"};
});


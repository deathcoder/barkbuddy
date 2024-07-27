import {onRequest} from "firebase-functions/v2/https";
import {logger} from "firebase-functions/v2";
import admin from "firebase-admin";

const app = admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
export const notification = onRequest((request, response) => {
  if (request.method !== "POST") {
    response.status(200).send();
    return;
  }

  const requestBody = JSON.parse(JSON.stringify(request.body));
  const notificationTitle = requestBody.title;
  const notificationBody = requestBody.body;
  const targetDeviceFCMToken = requestBody.token;

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
  const promise = app.messaging().send(message)
      .then((messagingResponse) => {
        // Response is a message ID string.
        logger.log("Successfully sent message:", messagingResponse);
        response.send({status: "ok"});
      })
      .catch((error) => {
        logger.log("Error sending message:", error);
        response.status(500).send({status: `error sending message ${error}`});
      });
  return promise;
});


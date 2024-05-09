/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentCreated, Change, FirestoreEvent } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

// Make sure you call initializeApp() before using any of the Firebase services
admin.initializeApp();

const db = admin.firestore();

const usersCached = new Map();

function getUserName(userId) {
    if (usersCached.has(userId)) {
        return Promise.resolve(usersCached.get(userId));
    }

    return db.collection('users').doc(userId).get()
        .then(userSnapshot => {
            if (userSnapshot.exists) {
                const data = userSnapshot.data();
                usersCached.set(userId, data.name);
                return data.name;
            } else {
                throw new Error('No such user!');
            }
        });
}

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Cloud firestore trigger ref: https://firebase.google.com/docs/functions/firestore-events
exports.onChatMessageCreated = onDocumentCreated("chatRooms/{roomId}/messages/{messageId}", (event) =>
{
    const data = event.data();
    logger.info("New message: ", data);

    const topic = `fcm/chatRooms/${event.params.roomId}`
    return getUserName(data.sender).then((userName) =>
    {
        return admin.messaging().sendToTopic(topic, {
            // sending a notification message
            notification: {
                title: userName ?? 'New title',
                body: data.message ?? 'New body',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });
});
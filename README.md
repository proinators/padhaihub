# PadhaiHub

PadhaiHub - an app that campus students can use to chat and share notes as PDFs with each other.
Notes can be shared on personal one-to-one chats as well as on a public forum.

## Implementation

The app is meant to allow for realtime chatting and file sharing.
Tech stack to be used along with Flutter:
1. Backend
   * [Firebase](https://firebase.google.com):
     * OAuth login for authentication
     * Realtime streams for messages
     * Provides storage for PDFs.
     * Host cloud functions (say, for listening to changes in chats and pushing notifications)
     * [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging): In case push notifications are implemented, FCM will be set up for the project.
2. Client Logic
   * Firebase for Flutter: To integrate Firebase with the app, incl. the core package, Firestore, Firebase Auth, Firebase Storage, [firebase_ui_firestore](https://pub.dev/packages/firebase_ui_firestore) 
   * [firebase-messaging](https://pub.dev/packages/firebase_messaging): For setting up FCM on the client side, separately mentioned as it is optional
   * [libsignal_protocol_dart](https://pub.dev/packages/libsignal_protocol_dart): (Optional) Messages will be made end-to-end encrypted using an implementation of the Signal Protocol
   * [bloc](https://bloclibrary.dev/): For state management on the client side
3. UI/UX
   * [curved_navigation_bar](https://pub.dev/packages/curved_navigation_bar): An interesting widget which I might use instead of the Material bottom nav bar if it fits with the rest of the UI design
   * [shimmer](https://pub.dev/packages/shimmer): For the shimmer animations during loads
   * [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui/): Along with the sister package [flutter_firebase_chat_core](https://pub.dev/packages/flutter_firebase_chat_core), it provides a complete UI and integration with Firebase for chats.
   * [dynamic_color](https://pub.dev/packages/dynamic_color/): Integrate with the device accent colors.

## Roadmap
Note: This may be updated along the way with changes in the features planned
- [x] Set up the Firebase project
- [x] Set up the Bloc skeleton
- [x] Implement Google OAuth with a simple landing page pre- and post-login
- [ ] Work on a simple theme and branding, which may be changed later
- [x] Set up Firestore, and add users to it
- [x] Start work on a student discovery page and set up a user profile page
- [x] Integrate flutter_chat_ui with the Firebase project and set up simple text chats
- [ ] Implement push notifications
- [ ] Set up file sharing on one-one chats
- [ ] Set up a public file sharing platform with topic-based categorization
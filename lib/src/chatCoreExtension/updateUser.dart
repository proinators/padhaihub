import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

extension UpdateUser on FirebaseChatCore {
  Future<bool> checkIfExists(String userId) async {
    try {
      bool exists = (await getFirebaseFirestore()
          .collection(config.usersCollectionName).doc(userId).get()).exists;
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserInFirestore(types.User user) async {
    await getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(user.id)
        .set({
      'firstName': user.firstName,
      'imageUrl': user.imageUrl,
      'lastName': user.lastName,
      'lastSeen': FieldValue.serverTimestamp(),
      'metadata': user.metadata,
      'role': user.role?.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLastSeen(String userId) async {
    await getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(userId)
        .update({
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
}

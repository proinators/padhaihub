import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

extension CurrUser on FirebaseChatCore {
  Stream<types.User> currUser() {
    if (firebaseUser == null) return const Stream.empty();
    return getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<List<types.User>>(
        [],
            (previousValue, doc) {
          if (firebaseUser!.uid != doc.id) return previousValue;

          final data = doc.data();

          data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
          data['id'] = doc.id;
          data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
          data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

          return [types.User.fromJson(data)];
        },
      )[0],
    );
  }
}
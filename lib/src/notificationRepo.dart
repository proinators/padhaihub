import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/src/chatCoreExtension/chatCoreExtension.dart';

class NotificationRepository {
  const NotificationRepository({required this.token});

  final String? token;

  Future<void> setTokenForUser(String userId) async {
    await FirebaseChatCore.instance.getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.usersCollectionName)
        .doc(userId)
        .update({
          "notification_token": token
        });
  }

  Future<void> removeTokenFromUser(String userId) async {
    await FirebaseChatCore.instance.getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.usersCollectionName)
        .doc(userId)
        .update({
          "notification_token": ""
        });
  }
}
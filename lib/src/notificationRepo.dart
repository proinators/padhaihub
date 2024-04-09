import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/src/chatCoreExtension/chatCoreExtension.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  NotificationRepository();

  late String? token;
  late void Function(RemoteMessage) _onMessageTapped;

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> init(void Function(RemoteMessage) onTap) async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    token = await FirebaseMessaging.instance.getToken();
    _onMessageTapped = onTap;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTapped);
    http.get(Uri.parse('https://padhaihub-service.onrender.com/')).then((value) => print("Connected to: " + value.body));
  }

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

  Future<Map<String, dynamic>> sendNotification(String toUserId, String roomId) async {
    final result = jsonDecode((await http.get(Uri.parse('https://padhaihub-service.onrender.com/send/$toUserId/$roomId'))).body);
    print(result);
    return result;
  }
}
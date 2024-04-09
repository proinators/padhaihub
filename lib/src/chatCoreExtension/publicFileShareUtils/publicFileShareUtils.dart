import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Future<types.Room> processPublicRoomQuery(
    FirebaseFirestore instance,
    DocumentSnapshot<Map<String, dynamic>> query,
    String usersCollectionName,
    ) async {
  return await processPublicRoomDocument(
      query,
      instance,
      usersCollectionName,
    );
}

Future<types.Room> processPublicRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    FirebaseFirestore instance,
    String usersCollectionName,
    ) async {
  final data = doc.data()!;

  data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
  data['id'] = doc.id;
  data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

  var imageUrl = data['imageUrl'] as String?;
  var name = data['name'] as String?;

  final users = [];


  data['imageUrl'] = imageUrl;
  data['name'] = name;
  data['users'] = users;

  if (data['lastMessages'] != null) {
    final lastMessages = data['lastMessages'].map((lm) {
      final author = lm['authorId'] as String;

      lm['author'] = author;
      lm['createdAt'] = lm['createdAt']?.millisecondsSinceEpoch;
      lm['id'] = lm['id'] ?? '';
      lm['updatedAt'] = lm['updatedAt']?.millisecondsSinceEpoch;

      return lm;
    }).toList();

    data['lastMessages'] = lastMessages;
  }

  return types.Room.fromJson(data);
}
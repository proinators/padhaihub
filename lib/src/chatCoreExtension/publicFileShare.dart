import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/src/chatCoreExtension/publicFileShareUtils/publicFileShareUtils.dart';
import 'package:uuid/uuid.dart';

final PUBLIC_ROOM_ID = Uuid().v5("room_id", "public_room");

extension PublicFileShare on FirebaseChatCore {
  Future<types.Room> ensureRoom() async {
    final userIds = [];
    final roomQuery = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .where('type', isEqualTo: types.RoomType.direct.toShortString())
        .where('id', isEqualTo: PUBLIC_ROOM_ID)
        .limit(1)
        .get();

    // Check if room already exist.
    if (roomQuery.docs.isNotEmpty) {
      final room = (await processPublicRoomQuery(
          getFirebaseFirestore(),
          roomQuery,
          config.usersCollectionName,
      )).first;
      return room;
    }

    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(PUBLIC_ROOM_ID)
        .set({
          'createdAt': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'name': "Public",
          'type': types.RoomType.direct.toShortString(),
          'updatedAt': FieldValue.serverTimestamp(),
          'userIds': userIds,
          'userRoles': null,
        }
    );
    return types.Room(
      id: PUBLIC_ROOM_ID,
      type: types.RoomType.direct,
      users: const [],
    );
  }
}
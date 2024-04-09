import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/config/config.dart';
import 'package:padhaihub/src/chatCoreExtension/publicFileShareUtils/publicFileShareUtils.dart';
import 'package:stream_transform/stream_transform.dart';

extension PublicFileShare on FirebaseChatCore {
  Future<types.Room> ensurePublicRoom() async {
    final userIds = [];
    final roomQuery = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(PUBLIC_ROOM_ID)
        .get();

    // Check if room already exist.
    if (roomQuery.exists) {
      final room = (await processPublicRoomQuery(
          getFirebaseFirestore(),
          roomQuery,
          config.usersCollectionName,
      ));
      return room;
    }

    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(PUBLIC_ROOM_ID)
        .set({
          'createdAt': FieldValue.serverTimestamp(),
          'imageUrl': null,
          'name': "Public",
          'metadata': {},
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

  Stream<types.Room> publicRoomStream() {
    return getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(PUBLIC_ROOM_ID)
        .snapshots()
        .asyncMap(
            (query) => processPublicRoomQuery(
                getFirebaseFirestore(),
                query,
                config.usersCollectionName,
            )
    );
  }

  Stream<List<types.Message>> publicRoomMessages(types.Room room) {
    return messages(room).combineLatest(
        users(),
        (messageList, userList) {
          return messageList.map(
              (message) => message.copyWith(
                  author: userList.where((user) => user.id == message.author.id).firstOrNull
              )
          ).toList();
        }
    );
  }

  Stream<int> unreadNotes(types.Room room, String currUserId) {
    return messages(room).map(
            (messagesList) => (messagesList.length - (room.metadata?[currUserId] ?? 0)).clamp(0, double.infinity).toInt()
    );
  }
}
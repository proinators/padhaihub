import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/config/config.dart';
import 'package:padhaihub/src/src.dart';

extension SeenStatus on FirebaseChatCore {
  Future<void> seeAll(types.User user, types.Room currRoom, {int? numberMessages, Map<String, dynamic>? metadata}) async {

    if (metadata == null) {
      metadata = currRoom.metadata ?? (await FirebaseChatCore.instance.getLiveMetadata(currRoom.id));
    }
    print(currRoom.id);
    print("See all messages");
    if(currRoom.id != PUBLIC_ROOM_ID) {
      metadata[user.id] = DateTime.timestamp().millisecondsSinceEpoch;
    } else {
      metadata[user.id] = numberMessages!;
    }
    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(currRoom.id)
        .update({
      'metadata': metadata,
    }
    );
  }

  Stream<Map<String, dynamic>> liveMetadata(String roomId) {
    if(roomId == PUBLIC_ROOM_ID) {
      return publicRoomStream().map((event) => event.metadata ?? {});
    }
    return rooms().map(
        (rooms) => rooms.where((e) => e.id == roomId).first.metadata ?? {}
    );
  }

  Future<Map<String, dynamic>> getLiveMetadata(String roomId) async {
    if(roomId == PUBLIC_ROOM_ID) {
      return await publicRoomStream().map((event) => event.metadata ?? {}).first;
    }
    return await rooms().map(
            (rooms) => rooms.where((e) => e.id == roomId).first.metadata ?? {}
    ).first;
  }

  Stream<List<types.Room>> unreadChats(String currUserId) {
    return rooms().map(
            (rooms) => rooms.where(
                    (room) {
                      return room.metadata?[currUserId] < room.updatedAt;
                    }
            ).toList()
    );
  }
}
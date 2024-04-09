import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/config/config.dart';
import 'package:padhaihub/src/src.dart';

extension SeenStatus on FirebaseChatCore {
  void seeAll(types.User user, types.Room currRoom, {int? numberMessages}) async {
    if(currRoom.id != PUBLIC_ROOM_ID) {
      currRoom.metadata?[user.id] = DateTime.timestamp().millisecondsSinceEpoch;
    } else {
      currRoom.metadata?[user.id] = numberMessages!;
    }
    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(currRoom.id)
        .update({
      'metadata': currRoom.metadata,
    }
    );
  }

  Stream<Map<String, dynamic>> getLiveMetadata(String roomId) {
    if(roomId == PUBLIC_ROOM_ID) {
      return publicRoomStream().map((event) => event.metadata ?? {});
    }
    return rooms().map(
        (rooms) => rooms.where((e) => e.id == roomId).first.metadata ?? {}
    );
  }

  Stream<List<types.Room>> unreadChats(String currUserId) {
    return rooms().map(
            (rooms) => rooms.where(
                    (room) => room.metadata?[currUserId] < room.updatedAt
            ).toList()
    );
  }
}
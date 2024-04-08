import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

extension SeenStatus on FirebaseChatCore {
  void seeAll(types.User user, types.Room currRoom) async {
    currRoom.metadata?[user.id] = DateTime.timestamp().millisecondsSinceEpoch;
    final room = await getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(currRoom.id)
        .update({
      'metadata': currRoom.metadata,
    }
    );
  }

  Stream<Map<String, dynamic>> getLiveMetadata(String roomId) {
    return FirebaseChatCore.instance.rooms().map(
        (rooms) => rooms.where((e) => e.id == roomId).first.metadata ?? {}
    );
  }

  Stream<List<types.Room>> unreadChats(String currUserId) {
    return FirebaseChatCore.instance.rooms().map(
            (rooms) => rooms.where(
                    (room) => room.metadata?[currUserId] < room.updatedAt
            ).toList()
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(types.User authUser, types.Room room) : super(ChatState.roomStart(authUser, room));

  final uuid = Uuid();

  String uuidGen() {
    return uuid.v4();
  }

  void onSendPressed(types.PartialText message) {
    // final textMessage = types.TextMessage(
    //   author: state.authUser,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: uuidGen(),
    //   text: message.text,
    // );
    FirebaseChatCore.instance.sendMessage(message, state.room!.id);
    // emit(state.copyWithMessage(textMessage));
  }

  void updateRoom(types.Room room) {
    emit(ChatState.roomStart(state.authUser, room));
  }
}

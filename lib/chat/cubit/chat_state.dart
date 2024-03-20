part of 'chat_cubit.dart';

final class ChatState extends Equatable {
  const ChatState._({required this.authUser, this.room, this.messages});

  final types.User authUser;
  final types.Room? room;
  final List<types.Message>? messages;

  @override
  List<Object> get props => [room?.id ?? ""];

  const ChatState.initial(types.User authUser) : this._(authUser: authUser, room: null);
  const ChatState.roomStart(types.User authUser, types.Room room) : this._(authUser: authUser, room: room);

  ChatState copyWith({types.Room? room, List<types.Message>? messages}) {
    return ChatState._(
      authUser: authUser,
      room: room ?? this.room,
      messages: messages ?? this.messages
    );
  }

  ChatState copyWithMessage(types.Message message) {
    return ChatState._(
      authUser: authUser,
      room: this.room,
      messages: [message] + (messages ?? [])
    );
  }
}

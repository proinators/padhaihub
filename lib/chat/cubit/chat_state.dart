part of 'chat_cubit.dart';

final class ChatState extends Equatable {
  const ChatState._({required this.authUser, this.room, this.messages});

  final types.User? authUser;
  final types.Room? room;
  final List<types.Message>? messages;

  @override
  List<Object> get props => [authUser?.id ?? "", room?.id ?? ""];

  const ChatState.initial() : this._(authUser: null, room: null);
  const ChatState.roomStart(types.Room room) : this._(authUser: null, room: room);

  ChatState copyWith({types.User? authUser, types.Room? room, List<types.Message>? messages}) {
    return ChatState._(
      authUser: authUser ?? this.authUser,
      room: room ?? this.room,
      messages: messages ?? this.messages,
    );
  }

  ChatState copyWithMessage(types.Message message) {
    return ChatState._(
      authUser: authUser,
      room: room,
      messages: [message] + (messages ?? []),
    );
  }
}

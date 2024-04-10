part of 'chat_cubit.dart';

final class ChatState extends Equatable {
  const ChatState._({required this.authUser, this.room, this.messages, this.isLoading=false, this.metadata});

  final types.User? authUser;
  final types.Room? room;
  final Map<String, dynamic>? metadata;
  final List<types.Message>? messages;
  final bool isLoading;

  @override
  List<Object> get props => [authUser?.id ?? "", room?.id ?? "", isLoading, metadata.hashCode];

  const ChatState.initial() : this._(authUser: null, room: null);
  const ChatState.roomStart(types.Room room) : this._(authUser: null, room: room);

  ChatState copyWith({types.User? authUser, types.Room? room, List<types.Message>? messages, bool? isLoading, Map<String, dynamic>? metadata}) {
    types.Room? newRoom = room ?? this.room;
    return ChatState._(
      authUser: authUser ?? this.authUser,
      room: newRoom?.copyWith(metadata: metadata),
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      metadata: metadata ?? this.metadata,
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

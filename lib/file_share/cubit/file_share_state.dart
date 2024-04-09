part of 'file_share_cubit.dart';

class FileShareState extends Equatable {
  const FileShareState._({required this.authUser, required this.room, this.messages, this.isLoading=false});

  final types.User? authUser;
  final types.Room room;
  final List<types.Message>? messages;
  final bool isLoading;

  const FileShareState.initial(types.Room room) : this._(authUser: null, room: room);

  @override
  List<Object> get props => [authUser?.id ?? "", room.id ?? "", isLoading];

  FileShareState copyWith({types.User? authUser, types.Room? room, List<types.Message>? messages, bool? isLoading}) {
    return FileShareState._(
      authUser: authUser ?? this.authUser,
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading
    );
  }

  FileShareState copyWithMessage(types.Message message) {
    return FileShareState._(
      authUser: authUser,
      room: room,
      messages: [message] + (messages ?? []),
    );
  }
}


import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/chat/chat.dart';
import 'package:padhaihub/chat/cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen._({super.key, required this.room});

  final types.Room room;

  static Page<void> page(types.Room room) =>
      MaterialPage<void>(child: ChatScreen._(room: room,));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChatCubit(context.read<AppBloc>().state.user.toChatUser(), room),
        child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          print(state.room?.id ?? "NULL ROOM ID");
          if (state.room?.id == "") {
            FirebaseChatCore.instance.createRoom(state.room!.users.first).then(
                    (room) {
                      context.read<ChatCubit>().updateRoom(room);
                      // TODO: Doesn't update the main navdata, temporary fix above
                      // context.flow<NavData>().complete(
                      //         (navData) => navData.copyWith(room: room)
                      // );
                    }
            );
            return Scaffold(
              body: LoadingWidget(),
            );
          }
          return StreamBuilder(
            initialData: [],
            stream: FirebaseChatCore.instance.messages(state.room!),
            builder: (context, snapshot) {
              return BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: ui.Chat(
                      messages: snapshot.data?.map<types.Message>((e) => e).toList() ?? [],
                      onSendPressed: context.read<ChatCubit>().onSendPressed,
                      user: state.authUser,
                    ),
                  );
                },
              );
            }
          );
        },
      ),
    );
  }
}

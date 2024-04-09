import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/src/src.dart';

class OverviewMessagesWidget extends StatelessWidget {
  const OverviewMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.unreadChats(context.read<AppBloc>().state.userModel.id),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))
              ),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? Column(
                    children: [
                      Text("You have messages from:", style: TextStyle(fontWeight: FontWeight.bold),),
                      ...snapshot.data!.map(
                              (room) => Text(room.name ?? "")
                      )
                    ],
                  )
                      : Center(
                    child: Text(
                        "No unread messages"
                    ),
                  )
              ),
            ),
          );
        }
    );
  }
}

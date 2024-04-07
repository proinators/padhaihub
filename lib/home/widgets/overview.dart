import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/src/src.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hi, ${context.read<AppBloc>().state.userModel.name}",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                StreamBuilder<List<types.Room>>(
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
                                "You're all caught up!"
                              ),
                            )
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      },
    );;
  }
}

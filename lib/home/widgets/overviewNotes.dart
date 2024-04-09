import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/src/src.dart';

class OverviewNotesWidget extends StatelessWidget {
  const OverviewNotesWidget({super.key, required this.storageRepository});

  final StorageRepository storageRepository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: FirebaseChatCore.instance.unreadNotes(storageRepository.publicRoom!, context.read<AppBloc>().state.userModel.id),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))
              ),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: (snapshot.hasData && snapshot.data != 0)
                      ? Column(
                    children: [
                      Text(
                          "You have ${snapshot.data} new notes!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  )
                      : Center(
                    child: Text(
                        "No new notes shared"
                    ),
                  )
              ),
            ),
          );
        }
    );
  }
}

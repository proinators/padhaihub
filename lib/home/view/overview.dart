import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/home/widgets/overviewMessages.dart';
import 'package:padhaihub/home/widgets/overviewNotes.dart';
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
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: OverviewMessagesWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: OverviewNotesWidget(storageRepository: context.read<AppBloc>().storageRepository),
                ),
              ],
            ),
          ),
        );
      },
    );;
  }
}

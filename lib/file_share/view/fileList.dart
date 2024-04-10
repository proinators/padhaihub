import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/config/consts.dart';
import 'package:padhaihub/file_share/file_share.dart';
import 'package:padhaihub/file_share/widget/uploadButton.dart';
import 'package:padhaihub/src/chatCoreExtension/chatCoreExtension.dart';
import 'package:searchable_listview/searchable_listview.dart';

class FileListPage extends StatefulWidget {
  FileListPage._({super.key});

  Timer? metadataWorker;

  static Page<void> page(types.Room room) =>
      MaterialPage<void>(child: FileListPage._());

  @override
  State<FileListPage> createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {

  @override
  void dispose() {
    widget.metadataWorker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FileShareCubit>(
      create: (context) {
        final cubit = FileShareCubit(context.read<AppBloc>().storageRepository);
        cubit.listenAuth();
        return cubit;
      },
      child: BlocBuilder<FileShareCubit, FileShareState>(
        builder: (context, state) {
          if (state.authUser == null) {
            return const Scaffold(
              body: LoadingWidget(),
            );
          }
          types.Room room = context.read<FileShareCubit>().storageRepo.publicRoom!;
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Public Notes"),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<types.Message>>(
                  stream: FirebaseChatCore.instance.publicRoomMessages(room),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const LoadingWidget();
                    }
                    if (snapshot.data!.isEmpty) {
                      return const EmptyWidget();
                    }
                    List<types.FileMessage> messages = snapshot.data!.where((element) => element is types.FileMessage).cast<types.FileMessage>().toList();
                    FileShareCubit cubit = context.read<FileShareCubit>();
                    if (!cubit.metadataLock) {
                      cubit.metadataLock = true;
                      FirebaseChatCore.instance.seeAll(state.authUser!, state.room, numberMessages: messages.length);
                    }
                    if(widget.metadataWorker == null) {
                      widget.metadataWorker = Timer.periodic(
                          METADATA_WORKER_CLOCK,
                              (timer) {
                            cubit.metadataLock = false;
                            cubit.getLiveMetadata();
                          }
                      );
                    }
                    return SearchableList(
                      initialList: messages,
                      builder: (List<types.FileMessage> filteredMessages, int index, types.FileMessage message) {
                        return FileListTile(
                          message: message,
                        );
                      },
                      filter: (value) => messages.where(
                        (element) =>
                          (element.author.firstName?.toLowerCase().contains(value.toLowerCase()) ?? false)
                            || (element.author.metadata?["id"].toString().contains(value.toLowerCase()) ?? false)
                            || (element.name.toLowerCase().contains(value.toLowerCase()))
                      ).toList(),
                      emptyWidget: EmptyWidget(),
                      inputDecoration: InputDecoration(
                        labelText: "Search for a note",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    );
                  }
              ),
            ),
            floatingActionButton: FloatingUploadButton(
              onPressed: context.read<FileShareCubit>().onUpload,
              isLoading: state.isLoading,
            ),
          );
        },
      ),
    );
  }
}

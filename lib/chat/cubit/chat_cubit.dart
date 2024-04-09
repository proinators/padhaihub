import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:open_filex/open_filex.dart';
import 'package:padhaihub/src/src.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(StorageRepository storageRepository, types.Room room)
      : storageRepo = storageRepository, super(ChatState.roomStart(room));

  final uuid = Uuid();
  final StorageRepository storageRepo;

  String uuidGen() {
    return uuid.v4();
  }

  void setUploadingStatus(bool val) {
    emit(state.copyWith(isLoading: val));
  }

  void listenAuth() async {
    FirebaseChatCore.instance.currUser().listen(
            (event) {
              emit(state.copyWith(authUser: event));
            }
    );
  }

  void onSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.updateLastSeen(FirebaseChatCore.instance.firebaseUser!.uid);
    FirebaseChatCore.instance.sendMessage(message, state.room!.id);
  }

  void onAttachmentPressed() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Choose a PDF to be sent",
      type: FileType.custom,
      allowedExtensions: ["pdf"]
    );

    if (!result!.files.single.path!.endsWith(".pdf")) {
      // emit(state.copyWith(errorMessage: "Please choose a PDF file."));
      showToastMessage("Please choose a PDF file.");
    }

    String fileUuid = uuidGen();
    try {
      setUploadingStatus(true);
      storageRepo.uploadFile("$fileUuid.pdf", result.files.single.path!, state.room!, state.authUser!).then(
          (value) {
            setUploadingStatus(false);
            if (result.files.single.path != null) {
              final message = types.PartialFile(
                name: result.files.single.name,
                size: result.files.single.size,
                uri: fileUuid,
              );
              FirebaseChatCore.instance.sendMessage(message, state.room!.id);
            }
          }
      );
    } catch (e) {
      // emit(state.copyWith(errorMessage: (e.toString() != "") ? e.toString() : "Could not upload file."));
      showToastMessage((e.toString() != "") ? e.toString() : "Could not upload file.");
      return;
    }

  }

  void onMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      String localFilename = await storageRepo.downloadFile(state.room!, message.uri, message.name, (TaskState taskState, String filePath) {
        switch(taskState) {
          case TaskState.paused:
            // emit(state.copyWith(infoMessage: "Download paused."));
            showToastMessage("Download paused.");
            break;
          case TaskState.running:
            // emit(state.copyWith(infoMessage: "Downloading..."));
            showToastMessage("Downloading...");
            break;
          case TaskState.success:
            closeAllToasts();
            OpenFilex.open(filePath);
            break;
          case TaskState.canceled:
            // emit(state.copyWith(infoMessage: "Download cancelled."));
            showToastMessage("Download cancelled.");
            break;
          case TaskState.error:
            // emit(state.copyWith(errorMessage: "Error in downloading."));
            showToastMessage("Error in downloading.");
            break;
        }
      });
      print(localFilename);
    }
  }

  void onMessageLongPress(BuildContext context, types.Message message) {
    if (message.author.id == state.authUser!.id) {
      showModalBottomSheet(context: context, builder: (BuildContext modalContext) {
        return SizedBox(
          height: (message is types.FileMessage) ? 200 : 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (message is types.FileMessage) ListTile(
                  leading: Icon(
                    Icons.edit_rounded,
                  ),
                  title: Text("Edit"),
                  onTap: () {
                    _editFileMessage(message);
                    Navigator.of(modalContext).pop();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    _deleteMessage(message);
                    Navigator.of(modalContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
    }
  }

  void onMessageDoubleTap(BuildContext context, types.Message p1) {
    // TODO: Reply to messages
  }

  void updateRoom(types.Room room) {
    emit(state.copyWith(room: room));
  }

  void _editFileMessage(types.Message message) async {
    if (message is types.FileMessage) {
      final result = await FilePicker.platform.pickFiles(
          dialogTitle: "Choose a PDF to be sent",
          type: FileType.custom,
          allowedExtensions: ["pdf"]
      );

      if (!result!.files.single.path!.endsWith(".pdf")) {
        // emit(state.copyWith(errorMessage: "Please choose a PDF file."));
        showToastMessage("Please choose a PDF file.");
      }

      String fileUuid = uuidGen();
      try {
        setUploadingStatus(true);
        storageRepo.uploadFile("$fileUuid.pdf", result.files.single.path!, state.room!, state.authUser!, isEdit: true).then(
          (value) => storageRepo.deleteFile(state.authUser!, state.room!, message, isEdit: true).then(
                  (_) {
                    setUploadingStatus(false);
                    FirebaseChatCore.instance.updateMessage(
                      message.copyWith(
                          name: result.files.single.name,
                          size: result.files.single.size,
                          uri: fileUuid
                      ),
                      state.room!.id
                  );
                  }));
      } catch (e) {
        // emit(state.copyWith(errorMessage: (e.toString() != "") ? e.toString() : "Could not upload file."));
        showToastMessage((e.toString() != "") ? e.toString() : "Could not upload file.");
        return;
      }

    }
  }

  void _deleteMessage(types.Message message) {
    FirebaseChatCore.instance.deleteMessage(state.room!.id, message.id);
    if (message is types.FileMessage) {
      storageRepo.deleteFile(state.authUser!, state.room!, message);
    }
  }

  void updateMetadata(Map<String, dynamic> metadata) {
    emit(state.copyWith(room: state.room?.copyWith(metadata: metadata)));
  }
}

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:equatable/equatable.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:open_filex/open_filex.dart';
import 'package:padhaihub/src/src.dart';
import 'package:uuid/uuid.dart';

part 'file_share_state.dart';

class FileShareCubit extends Cubit<FileShareState> {
  FileShareCubit(StorageRepository storageRepository)
      : storageRepo = storageRepository, super(FileShareState.initial(storageRepository.publicRoom!));

  final StorageRepository storageRepo;
  final uuid = Uuid();

  String uuidGen() {
    return uuid.v4();
  }

  void setUploadStatus(bool val) {
    emit(state.copyWith(isLoading: val));
  }

  void listenAuth() async {
    FirebaseChatCore.instance.currUser().listen(
            (event) {
          emit(state.copyWith(authUser: event));
        }
    );
  }

  void onUpload() async {
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
      emit(state.copyWith(isLoading:true));
      storageRepo.uploadFile("$fileUuid.pdf", result.files.single.path!, storageRepo.publicRoom!, state.authUser!).then(
              (value) {
            emit(state.copyWith(isLoading:false));
            if (result.files.single.path != null) {
              final message = types.PartialFile(
                name: result.files.single.name,
                size: result.files.single.size,
                uri: fileUuid,
              );
              FirebaseChatCore.instance.sendMessage(message, storageRepo.publicRoom!.id);
            }
          }
      );
    } catch (e) {
      // emit(state.copyWith(errorMessage: (e.toString() != "") ? e.toString() : "Could not upload file."));
      showToastMessage((e.toString() != "") ? e.toString() : "Could not upload file.");
      return;
    }

  }

  void onNoteTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      String localFilename = await storageRepo.downloadFile(state.room, message.uri, message.name, (TaskState taskState, String filePath) {
        switch(taskState) {
          case TaskState.paused:
            showToastMessage("Download paused.");
            break;
          case TaskState.running:
            showToastMessage("Downloading...");
            break;
          case TaskState.success:
            closeAllToasts();
            OpenFilex.open(filePath);
            break;
          case TaskState.canceled:
            showToastMessage("Download cancelled.");
            break;
          case TaskState.error:
            showToastMessage("Error in downloading.");
            break;
        }
      });
      print(localFilename);
    }
  }

  void onMoreTap(BuildContext context, types.Message message) {
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
        emit(state.copyWith(isLoading:true));
        storageRepo.uploadFile("$fileUuid.pdf", result.files.single.path!, state.room, state.authUser!, isEdit: true).then(
                (value) => storageRepo.deleteFile(state.authUser!, state.room, message, isEdit: true).then(
                    (_) {
                      emit(state.copyWith(isLoading:false));
                      FirebaseChatCore.instance.updateMessage(
                        message.copyWith(
                            name: result.files.single.name,
                            size: result.files.single.size,
                            uri: fileUuid
                        ),
                        state.room.id
                      );
                    }
                    ));
      } catch (e) {
        // emit(state.copyWith(errorMessage: (e.toString() != "") ? e.toString() : "Could not upload file."));
        showToastMessage((e.toString() != "") ? e.toString() : "Could not upload file.");
        return;
      }

    }
  }

  void _deleteMessage(types.Message message) {
    FirebaseChatCore.instance.deleteMessage(state.room.id, message.id);
    if (message is types.FileMessage) {
      storageRepo.deleteFile(state.authUser!, state.room, message);
    }
  }

  void updateMetadata(Map<String, dynamic> metadata) {
    emit(state.copyWith(room: state.room.copyWith(metadata: metadata)));
  }
}

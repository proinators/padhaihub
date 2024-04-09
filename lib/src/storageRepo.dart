import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:padhaihub/src/src.dart';

class StorageRepository {

  StorageRepository({
    CacheManager? cache,
  }) : _cache = cache ?? DefaultCacheManager();

  final CacheManager _cache;
  late Reference _storageRef;
  types.Room? publicRoom;

  Future<void> init() async {
    _storageRef = FirebaseStorage.instance.ref();
    publicRoom = await FirebaseChatCore.instance.ensurePublicRoom();
    FirebaseChatCore.instance.publicRoomStream().listen(
        (types.Room room) {
          publicRoom = room;
        }
    );
  }

  Future<void> uploadFile(String fileName, String localUri, types.Room room, types.User authUser, {bool isEdit=false}) async {
    if(!isEdit) {
      Map<String, dynamic> newMeta = authUser.metadata!;
      newMeta["files_shared"]++;
      FirebaseChatCore.instance.updateUserInFirestore(authUser.copyWith(metadata: newMeta));
    }
    // for (types.User user in users) {
    //   Reference userRef = _storageRef.child("users/${user.id}/$fileName");
    //   File file = File(localUri);
    //   await userRef.putFile(file);
    // }
    Reference userRef = _storageRef.child("rooms/${room.id}/$fileName");
    File file = File(localUri);
    await userRef.putFile(file);
  }

  Future<String> downloadFile(types.Room room, String uuid, String fileName, Function(TaskState, String) onTaskStateChange) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final filePath = "${tempDir.path}/$uuid/$fileName";
    if(await File(filePath).exists()) {
      onTaskStateChange(TaskState.success, filePath);
      return filePath;
    };
    final file = await File(filePath).create(recursive: true);

    // final downloadTask = _storageRef.child("users/$userId/$uuid.pdf").writeToFile(file);
    final downloadTask = _storageRef.child("rooms/${room.id}/$uuid.pdf").writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      onTaskStateChange(taskSnapshot.state, filePath);
    });
    final fileUrl =
        await _storageRef.child("rooms/${room.id}/$fileName").getDownloadURL();
    print(fileUrl);
    // return (await _cache.downloadFile(fileUrl)).file.path;
    return filePath;
  }

  Future<void> deleteFile(types.User authUser, types.Room room, types.FileMessage message, {bool isEdit=false}) async {
    if (message.author.id == authUser.id) {
      // (await FirebaseChatCore.instance.users().first).where((element) => element.id == authUser.id)
      if(!isEdit) {
        Map<String, dynamic> newMeta = message.author.metadata!;
        newMeta["files_shared"]--;
        FirebaseChatCore.instance.updateUserInFirestore(message.author.copyWith(metadata: newMeta));
      }
      // for (types.User user in room.users) {
      //   _storageRef.child("users/${user.id}/${message.uri}.pdf").delete();
      // }
      _storageRef.child("rooms/${room.id}/${message.uri}.pdf").delete();
    }
    // else {
    //   _storageRef.child("users/${authUser.id}/${message.uri}.pdf").delete();
    // }
  }
}
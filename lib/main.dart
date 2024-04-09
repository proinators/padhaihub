import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/src/notificationRepo.dart';
import 'package:padhaihub/src/src.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
  final fcmToken = await FirebaseMessaging.instance.getToken();

  // for iOS
  // final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  // if (apnsToken != null) {
  //   // APNS token is available, make FCM plugin API requests...
  // }
  final notificationRepository = NotificationRepository(token: fcmToken);
  final authenticationRepository = AuthenticationRepository(notificationRepository: notificationRepository);
  final storageRepository = StorageRepository();
  await authenticationRepository.user.first;
  await storageRepository.init();

  runApp(App(authenticationRepository: authenticationRepository, storageRepository: storageRepository,));
}


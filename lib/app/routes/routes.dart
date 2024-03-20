import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:padhaihub/app/app.dart';
import 'package:padhaihub/chat/chat.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/landing/landing.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    NavData navData,
    List<Page<dynamic>> pages,
    ) {
  if (kDebugMode)
    print("Entered App View Page Generator");
  switch (navData.appStatus) {
    case AppStatus.authenticated:
      return [
        TabbedHomePage.page(),
        if(navData.room != null) ChatScreen.page(navData.room!),
      ];
    case AppStatus.unauthenticated:
      return [LandingPage.page()];
    default:
      return [LoadingPage.page()];
  }
}

class NavData {
  const NavData({this.appStatus, this.homeStatus, this.room});

  final AppStatus? appStatus;
  final HomeStatus? homeStatus;
  final types.Room? room;

  NavData copyWith({AppStatus? appStatus, HomeStatus? homeStatus, types.Room? room}) {
    return NavData(
      appStatus: appStatus ?? this.appStatus,
      homeStatus: homeStatus ?? this.homeStatus,
      room: room ?? this.room,
    );
  }
}

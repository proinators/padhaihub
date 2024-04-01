import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/home/widgets/discoverUsersList.dart';
import 'package:padhaihub/home/widgets/overview.dart';
import 'package:padhaihub/home/widgets/profile.dart';

Widget generateTabPage(HomeState state) {
  switch(state.status) {
    case HomeStatus.initial:
      return Container();
    case HomeStatus.overview:
      return OverviewTab();
    case HomeStatus.chat:
      return ChatTab();
    case HomeStatus.discoverUser:
      return DiscoverUserTab();
    case HomeStatus.profile:
      return ProfileTab();
  }
}

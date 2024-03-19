import 'package:flutter/material.dart';
import 'package:padhaihub/home/home.dart';
import 'package:padhaihub/home/widgets/overview.dart';

Widget generateTabPage(HomeState state) {
  switch(state.status) {
    case HomeStatus.initial:
      return Container();
    case HomeStatus.overview:
      return OverviewTab();
    case HomeStatus.chat:
      return ChatTab();
  }
}
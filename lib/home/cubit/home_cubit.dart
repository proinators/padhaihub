import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:padhaihub/src/src.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.overview());

  List<List> getPageIcons() {
    return [
      [Icons.home_rounded, "Home"],
      [Icons.chat_bubble_rounded, "Chat"],
      [Icons.explore, "Explore"],
      [Icons.person_3_rounded, "You"]
    ];
  }

  void changePage(int index) {
    switch(index) {
      case 0:
        emit(HomeState.overview());
        break;
      case 1:
        emit(HomeState.chat());
        break;
      case 2:
        emit(HomeState.discoverUser());
        break;
      case 3:
        emit(HomeState.profile());
        break;
    }
  }
}

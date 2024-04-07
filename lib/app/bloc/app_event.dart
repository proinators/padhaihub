part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppInitial extends AppEvent {
  const AppInitial();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.userModel);

  final UserModel userModel;
}
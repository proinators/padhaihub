part of 'app_bloc.dart';

enum AppStatus {
  initial,
  authenticated,
  unauthenticated,
}

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = UserModel.empty,
  });

  const AppState.initial() : this._(status: AppStatus.initial);

  const AppState.authenticated(UserModel user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final UserModel user;

  @override
  List<Object> get props => [status, user];
}
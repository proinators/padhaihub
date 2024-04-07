part of 'app_bloc.dart';

enum AppStatus {
  initial,
  authenticated,
  unauthenticated,
}

final class AppState extends Equatable {

  const AppState._({
    required this.status,
    this.userModel = UserModel.empty,
  });

  const AppState.initial() : this._(status: AppStatus.initial);

  const AppState.authenticated(UserModel userModel)
      : this._(status: AppStatus.authenticated, userModel: userModel);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final UserModel userModel;

  @override
  List<Object> get props => [status, userModel];
}
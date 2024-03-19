part of 'home_cubit.dart';

enum HomeStatus {
  overview,
  chat,
  initial,
}

final class HomeState extends Equatable {
  const HomeState._({required this.status});

  const HomeState.initial() : this._(status: HomeStatus.initial);
  const HomeState.overview() : this._(status: HomeStatus.overview);
  const HomeState.chat() : this._(status: HomeStatus.chat);

  @override
  List<Object?> get props => [status];

  final HomeStatus status;

  HomeState copyWith({HomeStatus? status, UserModel? user}) {
    return HomeState._(status: status ?? this.status);
  }
}


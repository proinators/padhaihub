part of 'home_cubit.dart';

enum HomeStatus {
  overview,
  chat,
  discoverUser,
  profile,
  initial,
}

final class HomeState extends Equatable {
  const HomeState._({required this.status, this.prevStatus=HomeStatus.initial});

  const HomeState.initial(HomeStatus prevStatus) : this._(status: HomeStatus.initial, prevStatus: prevStatus);
  const HomeState.overview(HomeStatus prevStatus) : this._(status: HomeStatus.overview, prevStatus: prevStatus);
  const HomeState.discoverUser(HomeStatus prevStatus) : this._(status: HomeStatus.discoverUser, prevStatus: prevStatus);
  const HomeState.chat(HomeStatus prevStatus) : this._(status: HomeStatus.chat, prevStatus: prevStatus);
  const HomeState.profile(HomeStatus prevStatus) : this._(status: HomeStatus.profile, prevStatus: prevStatus);

  @override
  List<Object?> get props => [status];

  final HomeStatus status;
  final HomeStatus prevStatus;

  HomeState copyWith({HomeStatus? status, HomeStatus? prevStatus}) {
    return HomeState._(status: status ?? this.status, prevStatus: prevStatus ?? this.prevStatus);
  }
}


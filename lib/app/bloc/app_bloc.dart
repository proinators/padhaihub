
import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:padhaihub/src/src.dart';


part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository, required this.storageRepository})
      : _authenticationRepository = authenticationRepository,
        super(AppState.initial()) {
    on<AppInitial>(_onInit);
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
          (user) {
            add(_AppUserChanged(user));
          },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final StorageRepository storageRepository;
  late final StreamSubscription<UserModel> _userSubscription;

  void _onInit(AppInitial event, Emitter<AppState> emit) async {
    final userModel = await _authenticationRepository.currentUser;
    emit(
      userModel.isNotEmpty
          ? AppState.authenticated(userModel)
          : const AppState.unauthenticated(),
    );
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.userModel.isNotEmpty
          ? AppState.authenticated(event.userModel)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

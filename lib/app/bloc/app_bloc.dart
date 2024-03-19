
import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../src/authRepo.dart';
import '../../src/models/models.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AppState.initial()) {
    on<AppInitial>(_onInit);
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
          (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<UserModel> _userSubscription;

  void _onInit(AppInitial event, Emitter<AppState> emit) async {
    final user = await _authenticationRepository.currentUser;
    emit(
      user.isNotEmpty
          ? AppState.authenticated(user)
          : const AppState.unauthenticated(),
    );
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
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

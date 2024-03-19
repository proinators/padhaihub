part of 'landing_cubit.dart';


// final class LandingState extends Equatable {
//   const LandingState({
//     this.email = const Email.pure(),
//     this.password = const Password.pure(),
//     this.status = FormzSubmissionStatus.initial,
//     this.isValid = false,
//     this.errorMessage,
//   });
//
//   final Email email;
//   final Password password;
//   final FormzSubmissionStatus status;
//   final bool isValid;
//   final String? errorMessage;
//
//   @override
//   List<Object?> get props => [email, password, status, isValid, errorMessage];
//
//   LoginState copyWith({
//     Email? email,
//     Password? password,
//     FormzSubmissionStatus? status,
//     bool? isValid,
//     String? errorMessage,
//   }) {
//     return LoginState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       status: status ?? this.status,
//       isValid: isValid ?? this.isValid,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

final class LandingState extends Equatable {
  const LandingState({
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status];

  LandingState copyWith({
    FormzSubmissionStatus? status,
    String? errorMessage
  }) {
    return LandingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

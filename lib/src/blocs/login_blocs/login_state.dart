// part of 'login_bloc.dart';

// class LoginState extends Equatable {
//   LoginState({
//     this.status = FormzStatus.pure,
//     this.username = const Username.pure(),
//     this.password = const Password.pure(),
//   });

//   final FormzStatus status;
//   final Username username;
//   final Password password;

//   LoginState copyWith({
//     FormzStatus? status,
//     Username? username,
//     Password? password,
//   }) {
//     return LoginState(
//       status: status ?? this.status,
//       username: username ?? this.username,
//       password: password ?? this.password,
//     );
//   }

//   @override
//   List<Object> get props => [status, username, password];
// }




// // abstract class LoginState extends Equatable {
// //   LoginState();

// //   List<Object> get props => [];
// // }

// // class AuthenticationStateEmpty extends LoginState {}

// // class AuthenticationUnknown extends LoginState {}

// // class AuthenticationUnauthenticated extends LoginState {}

// // class AuthenticationAuthenticated extends LoginState {
// //   AuthenticationAuthenticated(this.items);

// //   final User items;

// //   @override
// //   List<Object> get props => [items];
// // }

// // class SearchStateError extends LoginState {
// //   SearchStateError(this.error);

// //   final String error;

// //   @override
// //   List<Object> get props => [error];
// // }

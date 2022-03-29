import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

// class UsernameChanged extends AuthenticationEvent {
//   const UsernameChanged({required this.username});

//   final String username;

//   List<Object> get props => [username];
// }

// class PasswordChanged extends AuthenticationEvent {
//   const PasswordChanged({required this.password});

//   final String password;

//   List<Object> get props => [password];
// }

class LoginPressed extends AuthenticationEvent {
  const LoginPressed({required this.password, required this.username});

  final String username;
  final String password;

  List<Object> get props => [password];
}

class LogoutPressed extends AuthenticationEvent {
  const LogoutPressed();

  List<Object> get props => [];
}

import 'package:bloc_movie_my/src/user/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationStateEmpty extends AuthenticationState {}

class AuthenticationStateLoading extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {
  AuthenticationStateSuccess(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AuthenticationStateError extends AuthenticationState {
  AuthenticationStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

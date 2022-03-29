import 'package:bloc_movie_my/src/app.dart';
import 'package:bloc_movie_my/src/resources/authentication_repository.dart';
import 'package:bloc_movie_my/src/resources/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(Dio()),
    userRepository: UserRepository(Dio()),
  ));
}

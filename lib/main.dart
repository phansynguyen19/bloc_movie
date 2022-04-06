import 'package:bloc_movie_my/src/app.dart';
import 'package:bloc_movie_my/src/resources/authentication_repository.dart';
import 'package:bloc_movie_my/src/resources/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    App(
      authenticationRepository: AuthenticationRepository(Dio()),
      userRepository: UserRepository(Dio()),
    ),
  );
}

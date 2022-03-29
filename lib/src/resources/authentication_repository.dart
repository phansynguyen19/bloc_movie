import 'dart:async';
import 'package:bloc_movie_my/src/models/authentication.dart';
import 'package:bloc_movie_my/src/user/models/user.dart';
import 'package:dio/dio.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  AuthenticationRepository(this.client);

  final Dio client;

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<User> logIn(String username, String password) async {
    try {
      var authentication = await getToken();
      print(authentication.requestToken);
      var result =
          await postCheckLogin(username, password, authentication.requestToken);
      var sessionId = await createSesstion(result.requestToken);

      User user = await getUser(sessionId.session_id);
      _controller.add(AuthenticationStatus.authenticated);
      return user;
    } catch (e) {
      throw (e);
    }
  }

  // Future<User> logIn2(
  //     String username, String password, String requestToken) async {
  //   try {
  //     print(username);
  //     var result = await postCheckLogin(username, password, requestToken);
  //     var sessionId = await createSesstion(result.requestToken);

  //     User user = await getUser(sessionId.session_id);
  //     _controller.add(AuthenticationStatus.authenticated);
  //     return user;
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future<void> logIn3({
  //   required String username,
  //   required String password,
  // }) async {
  //   await Future.delayed(
  //     const Duration(milliseconds: 300),
  //     () => _controller.add(AuthenticationStatus.authenticated),
  //   );
  // }

  Future<RequestTokenModel> getToken() async {
    try {
      const url =
          'https://api.themoviedb.org/3/authentication/token/new?api_key=4f8986ded5b1ada23d322b6cb0b6e403';

      final response = await client.get(url);

      final requestTokenModel = RequestTokenModel.fromJson(response.data);
      return requestTokenModel;
    } catch (e) {
      throw e;
    }
  }

  Future<RequestTokenModel> postCheckLogin(
      String username, String password, String request_token) async {
    String token = '4f8986ded5b1ada23d322b6cb0b6e403';

    try {
      final url =
          'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$token&username=$username&password=$password&request_token=$request_token';
      String json =
          '{"username": "$username", "password": "$password", "request_token": "$request_token"}';

      final response = await client.post(
        url,
        data: json,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );
      final requestTokenModel = RequestTokenModel.fromJson(response.data);
      return requestTokenModel;
    } catch (e) {
      throw e;
    }
  }

  Future<SessionModel> createSesstion(String request_token) async {
    String token = '4f8986ded5b1ada23d322b6cb0b6e403';

    try {
      final url =
          'https://api.themoviedb.org/3/authentication/session/new?api_key=$token&request_token=$request_token';
      String json = '{"request_token": "$request_token"}';

      final response = await client.post(
        url,
        data: json,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );
      final requestTokenModel = SessionModel.fromJson(response.data);
      return requestTokenModel;
    } catch (e) {
      throw e;
    }
  }

  Future<User> getUser(String session_id) async {
    try {
      var url =
          'https://api.themoviedb.org/3/account?api_key=4f8986ded5b1ada23d322b6cb0b6e403&session_id=$session_id';
      // String json = '{"session_id": "$session_id"}';

      final response = await client.get(
        url,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );
      print(response.data);
      final user = User.fromJson(response.data);
      return user;
      // return User.fromJson(jsonDecode(response.data));
    } catch (e) {
      throw e;
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

import 'dart:async';
import 'package:bloc_movie_my/src/user/models/user.dart';
import 'package:dio/dio.dart';

class UserRepository {
  UserRepository(this.client);

  final Dio client;
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
}

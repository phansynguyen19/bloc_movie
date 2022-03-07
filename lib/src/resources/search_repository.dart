import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:dio/dio.dart';

class SearchRepository {
  const SearchRepository(this.client);

  final Dio client;

  Future<List<MovieModel>> getMovies(String query) async {
    try {
      final url =
          'https://api.themoviedb.org/3/search/movie?api_key=4f8986ded5b1ada23d322b6cb0b6e403&language=en-US&query=${query}';

      final response = await client.get(url);

      final movies = List<MovieModel>.of(
        response.data['results'].map<MovieModel>(
          (json) => MovieModel(
            title: json['title'],
            urlImage: 'https://image.tmdb.org/t/p/w185${json['poster_path']}',
          ),
        ),
      );
      return movies;
    } catch (e) {
      throw e;
    }
  }
}

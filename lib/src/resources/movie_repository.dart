import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:dio/dio.dart';

class MovieRepository {
  const MovieRepository(this.client);

  final Dio client;

  Future<List<MovieModel>> getMovies() async {
    try {
      const url =
          'https://api.themoviedb.org/3/trending/movie/week?api_key=060e7c76aff06a20ca4a875981216f3f';

      final response = await client.get(url);

      final movies = List<MovieModel>.of(
        response.data['results'].map<MovieModel>(
          (json) => MovieModel(
            title: json['title'],
            urlImage: 'https://image.tmdb.org/t/p/w185${json['poster_path']}',
            backdrop_path:
                'https://image.tmdb.org/t/p/w185${json['backdrop_path']}',
            overview: json['overview'],
          ),
        ),
      );
      return movies;
    } catch (e) {
      throw e;
    }
  }

  Future<List<MovieModel>> getMoviesByPage([int page = 1]) async {
    try {
      final url =
          'https://api.themoviedb.org/3/movie/popular?api_key=4f8986ded5b1ada23d322b6cb0b6e403&language=en-US&page=${page}';

      final response = await client.get(url);

      final movies = List<MovieModel>.of(
        response.data['results'].map<MovieModel>(
          (json) => MovieModel(
            title: json['title'],
            urlImage: 'https://image.tmdb.org/t/p/w185${json['poster_path']}',
            backdrop_path:
                'https://image.tmdb.org/t/p/w185${json['backdrop_path']}',
            overview: json['overview'],
          ),
        ),
      );
      return movies;
    } catch (e) {
      throw e;
    }
  }
}

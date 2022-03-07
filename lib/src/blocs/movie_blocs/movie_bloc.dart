import 'package:bloc_movie_my/src/blocs/movie_blocs/movie_event.dart';
import 'package:bloc_movie_my/src/blocs/movie_blocs/movie_state.dart';
import 'package:bloc_movie_my/src/resources/movie_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

// EventTransformer<Event> debounce<Event>(Duration duration) {
//   return (events, mapper) => events.debounce(duration).switchMap(mapper);
// }

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(MovieState intialState) : super(intialState) {
    on<GetMovieEvent>(
      _onStateChanged,
    );
  }

  final _movieRepository = MovieRepository(Dio());

  void _onStateChanged(
    GetMovieEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(InitialState());

    emit(LoadingState());

    try {
      final results = await _movieRepository.getMovies();
      emit(LoadedState(results));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }
}

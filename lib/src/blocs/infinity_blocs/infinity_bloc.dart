import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:bloc_movie_my/src/resources/movie_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';

part 'infinity_event.dart';
part 'infinity_state.dart';

// const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class InfinityBloc extends Bloc<InfinityEvent, InfinityState> {
  InfinityBloc() : super(const InfinityState()) {
    on<MovieFetched>(
      _onMovieFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<Initial>(
      _onRefresh,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onRefresh(Initial event, Emitter<InfinityState> emit) async {
    emit(
      state.copyWith(
        status: MovieStatus.initial,
        movie: <MovieModel>[],
        hasReachedMax: false,
      ),
    );
  }

  Future<void> _onMovieFetched(
      MovieFetched event, Emitter<InfinityState> emit) async {
    final _movieRepository = MovieRepository(Dio());
    if (state.hasReachedMax) return;
    try {
      int index = 1;
      if (state.status == MovieStatus.initial) {
        final movie = await _movieRepository.getMoviesByPage();
        print(movie.length);
        return emit(
          state.copyWith(
            status: MovieStatus.success,
            movie: movie,
            hasReachedMax: false,
          ),
        );
      }
      final movie = await _movieRepository.getMoviesByPage(index++);
      movie.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: MovieStatus.success,
                movie: List.of(state.movieModel)..addAll(movie),
                hasReachedMax: false,
              ),
            );
      print(state.movieModel.length);
    } catch (e) {
      emit(state.copyWith(status: MovieStatus.failure));
    }
  }
}

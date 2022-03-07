import 'package:bloc_movie_my/src/blocs/search_blocs/search_event.dart';
import 'package:bloc_movie_my/src/blocs/search_blocs/search_state.dart';
import 'package:bloc_movie_my/src/resources/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:dio/dio.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(SearchState intialState) : super(intialState) {
    on<TextChanged>(_onTextChanged,
        transformer: debounce(const Duration(milliseconds: 300)));
  }

  final _searchRepository = SearchRepository(Dio());

  void _onTextChanged(
    TextChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.text;

    if (query.isEmpty) return emit(SearchStateEmpty());

    emit(SearchStateLoading());

    try {
      final results = await _searchRepository.getMovies(query);
      emit(SearchStateSuccess(results));
    } catch (error) {
      emit(SearchStateError(error.toString()));
    }
  }
}

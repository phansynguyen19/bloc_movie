import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_event.dart';
import 'package:bloc_movie_my/src/blocs/authentication_blocs/authentication_state.dart';
import 'package:bloc_movie_my/src/resources/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:dio/dio.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationState intialState) : super(intialState) {
    on<LoginPressed>(_onLoginPressed,
        transformer: debounce(const Duration(milliseconds: 300)));
    on<LogoutPressed>(_onAuthenticationLogoutPressed,
        transformer: debounce(const Duration(milliseconds: 100)));
  }

  final _authenticationRepository = AuthenticationRepository(Dio());

  void _onLoginPressed(
    LoginPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    final username = event.username;
    final password = event.password;

    if (username.isEmpty || password.isEmpty)
      return emit(AuthenticationStateEmpty());

    emit(AuthenticationStateLoading());

    try {
      final results = await _authenticationRepository.logIn(username, password);
      emit(AuthenticationStateSuccess(results));
    } catch (error) {
      emit(AuthenticationStateError(error.toString()));
    }
  }

  void _onAuthenticationLogoutPressed(
    LogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(AuthenticationStateEmpty());
    // _authenticationRepository.logOut();
  }
  // void _onTextChanged(
  //   TextChanged event,
  //   Emitter<SearchState> emit,
  // ) async {
  //   final query = event.text;

  //   if (query.isEmpty) return emit(SearchStateEmpty());

  //   emit(SearchStateLoading());

  //   try {
  //     final results = await _searchRepository.getMovies(query);
  //     emit(SearchStateSuccess(results));
  //   } catch (error) {
  //     emit(SearchStateError(error.toString()));
  //   }
  // }
}

import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:equatable/equatable.dart';

abstract class MovieState extends Equatable {
  MovieState();
  List<Object> get props => [];
}

class InitialState extends MovieState {}

class LoadingState extends MovieState {}

class LoadedState extends MovieState {
  LoadedState(this.items);

  final List<MovieModel> items;

  @override
  List<Object> get props => [items];
}

class ErrorState extends MovieState {
  ErrorState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

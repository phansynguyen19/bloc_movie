import 'package:bloc_movie_my/src/models/movie_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  SearchState();

  List<Object> get props => [];
}

class SearchStateEmpty extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateSuccess extends SearchState {
  SearchStateSuccess(this.items);

  final List<MovieModel> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends SearchState {
  SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

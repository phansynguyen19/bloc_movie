import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class GetMovieEvent extends MovieEvent {
  GetMovieEvent();

  List<Object> get props => [];
}

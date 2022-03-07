part of 'infinity_bloc.dart';

enum MovieStatus { initial, success, failure, refresh }

class InfinityState extends Equatable {
  const InfinityState({
    this.status = MovieStatus.initial,
    this.movieModel = const <MovieModel>[],
    this.hasReachedMax = false,
  });

  final MovieStatus status;
  final List<MovieModel> movieModel;
  final bool hasReachedMax;

  InfinityState copyWith({
    MovieStatus? status,
    List<MovieModel>? movie,
    bool? hasReachedMax,
  }) {
    return InfinityState(
      status: status ?? this.status,
      movieModel: movie ?? this.movieModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, movieModel, hasReachedMax];
}

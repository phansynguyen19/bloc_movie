part of 'infinity_bloc.dart';

@immutable
abstract class InfinityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieFetched extends InfinityEvent {}

class Initial extends InfinityEvent {
  @override
  List<Object> get props => [];
}

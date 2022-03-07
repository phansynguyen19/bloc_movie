import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class TextChanged extends SearchEvent {
  const TextChanged({required this.text});

  final String text;

  List<Object> get props => [text];
}

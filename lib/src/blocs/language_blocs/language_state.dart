part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final Locale locale;

  LanguageState({required this.locale});

  factory LanguageState.initial() => LanguageState(locale: Locale('en', 'US'));

  LanguageState copyWith({required Locale locale}) =>
      LanguageState(locale: locale);

  @override
  List<Object> get props => [locale];
}

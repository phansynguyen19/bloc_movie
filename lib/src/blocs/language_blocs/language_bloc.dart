import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc(LanguageState initialState) : super(initialState) {
    on<LoadLanguage>(
      _onLoadLanguage,
    );
  }

  FutureOr<void> _onLoadLanguage(
      LoadLanguage event, Emitter<LanguageState> emit) {
    emit(LanguageState(locale: event.locale));
  }
}

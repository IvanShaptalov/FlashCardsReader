import 'package:bloc/bloc.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';

part 'translator_event.dart';
part 'translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  TranslatorBloc() : super(TranslatorState(result: '', source: '')) {
    on<TranslateEvent>((event, emit) async {
      if (Checker.isConnected) {
        emit(await state.translate(event.text, event.fromLan, event.toLan));
      }
    });

    on<ClearTranslateEvent>((event, emit) {
      emit(state.clear());
    });
  }
}

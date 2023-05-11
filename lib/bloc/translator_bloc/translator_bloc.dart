import 'package:bloc/bloc.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';

part 'translator_event.dart';
part 'translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorInitial> {
  TranslatorBloc() : super(TranslatorInitial(result: '')) {
    on<TranslateEvent>((event, emit) async {
      emit(await state.translate(event.text, event.fromLan, event.toLan));
    });
  }
}

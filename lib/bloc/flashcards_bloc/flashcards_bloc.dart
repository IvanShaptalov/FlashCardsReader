import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcards_event.dart';

part 'flashcards_state.dart';

class FlashcardsBloc extends Bloc<FlashCardsEvent, FlashCardsState> {
  FlashcardsBloc() : super(FlashCardsState.initial()) {
    on<IncrementCounter>((event, emit) => incrementCounter(event, emit));
    on<DecrementCounter>((event, emit) => decrementCounter(event, emit));
  }

  /// realisation of the event, event trigger emit
  incrementCounter(IncrementCounter event, Emitter<FlashCardsState> emit) {
    emit(state.copyWith(counterValue: state.counterValue + event.counterValue));
  }

  // realisation of the event, event trigger emit
  decrementCounter(DecrementCounter event, Emitter<FlashCardsState> emit) {
    emit(state.copyWith(counterValue: state.counterValue - event.counterValue));
  }
}

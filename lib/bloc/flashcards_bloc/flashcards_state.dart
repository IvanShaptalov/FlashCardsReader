part of 'flashcards_bloc.dart';
// initialization of data
class FlashCardsState {
  final int counterValue;

  FlashCardsState({required this.counterValue});

  factory FlashCardsState.initial() => FlashCardsState(counterValue: 0);

  FlashCardsState copyWith({int? counterValue}) {
    return FlashCardsState(
      counterValue: counterValue ?? this.counterValue,
    );
  }
}

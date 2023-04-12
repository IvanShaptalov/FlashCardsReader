part of 'flashcards_bloc.dart';
// flashcards event call it on the bloc
abstract class FlashCardsEvent {}

class IncrementCounter extends FlashCardsEvent {
  final int counterValue;

  IncrementCounter({required this.counterValue});
}

class DecrementCounter extends FlashCardsEvent {
  final int counterValue;

  DecrementCounter({required this.counterValue});
}

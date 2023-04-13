part of 'counter_bloc.dart';


abstract class CounterEvent {}

class IncrementCounter extends CounterEvent {
  final int counterValue;

  IncrementCounter({required this.counterValue});
}

class DecrementCounter extends CounterEvent {
  final int counterValue;

  DecrementCounter({required this.counterValue});
}



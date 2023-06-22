part of 'translator_bloc.dart';

abstract class TranslatorEvent {}

class TranslateEvent extends TranslatorEvent {
  String text;
  String fromLan;
  String toLan;

  TranslateEvent(
      {required this.text, required this.fromLan, required this.toLan});
}

class ClearTranslateEvent extends TranslatorEvent {}

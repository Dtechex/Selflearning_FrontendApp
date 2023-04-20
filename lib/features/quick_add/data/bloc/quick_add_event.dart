part of 'quick_add_bloc.dart';

@immutable
abstract class QuickAddEvent {}

class LoadQuickTypeEvent extends QuickAddEvent {}

class ButtonPressedEvent extends QuickAddEvent {
  final String? title;

  ButtonPressedEvent({this.title});
}

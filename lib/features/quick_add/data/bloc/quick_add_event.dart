part of 'quick_add_bloc.dart';

@immutable
abstract class QuickAddEvent {}

class LoadQuickTypeEvent extends QuickAddEvent {}

class ButtonPressedEvent extends QuickAddEvent {
  final int contentType;
  final String? title;

  ButtonPressedEvent({this.title,required this.contentType});
}

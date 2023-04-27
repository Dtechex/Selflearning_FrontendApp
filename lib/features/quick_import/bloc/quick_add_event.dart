part of 'quick_add_bloc.dart';

@immutable
abstract class QuickImportEvent {}

class LoadQuickTypeEvent extends QuickImportEvent {
  final String? ddValue;
  LoadQuickTypeEvent({this.ddValue});
}

class ButtonPressedEvent extends QuickImportEvent {
  final String? title;
  final String? quickAddId;
  final String? rootId;
  ButtonPressedEvent({this.title,this.quickAddId,this.rootId});
}

class ChangeDropValue extends QuickImportEvent {
   final List<QuickImportModel>? list;
  final String? title;
  ChangeDropValue({this.title,this.list});
}

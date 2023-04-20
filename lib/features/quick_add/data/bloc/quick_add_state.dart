part of 'quick_add_bloc.dart';

@immutable
abstract class QuickAddState {}

class QuickAddInitial extends QuickAddState {}

class QuickAddLoadingState extends QuickAddState{}

class QuickAddLoadedState extends QuickAddState{
  final List<QuickTypeModel>? list;
  QuickAddLoadedState({this.list});
}

class QuickAddErrorState extends QuickAddState{}

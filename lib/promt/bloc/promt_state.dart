part of 'promt_bloc.dart';

@immutable
abstract class PromtState {}

class PromtInitial extends PromtState {}

class PromtLoading extends PromtState {}

class PromtLoaded extends PromtState {
  final List<PromtModel> promtModel;

  PromtLoaded({required this.promtModel});
}
class PromtError extends PromtState {
  final String? error;
  PromtError({this.error});
}


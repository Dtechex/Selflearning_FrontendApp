part of 'promt_bloc.dart';

@immutable
abstract class PromtEvent {}
 class LoadPromtEvent extends PromtEvent {
 final String promtId;
 LoadPromtEvent({required this.promtId});
 }



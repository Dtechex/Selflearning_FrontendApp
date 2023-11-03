part of 'get_res_prompt_bloc.dart';

@immutable
abstract class GetResPromptEvent {}
class HitResPromptEvent extends GetResPromptEvent{
  String dailogId;
  HitResPromptEvent({required this.dailogId});

}


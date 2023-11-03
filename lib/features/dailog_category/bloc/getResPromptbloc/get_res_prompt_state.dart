part of 'get_res_prompt_bloc.dart';

@immutable
abstract class GetResPromptState {}

class GetResPromptInitial extends GetResPromptState {}
class GetResPromptLoading extends GetResPromptState {}
class GetResPromptSucess extends GetResPromptState {
  String success;
  GetResPromptSucess({required this.success});
}




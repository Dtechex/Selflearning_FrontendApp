part of 'add_prompt_res_cubit.dart';

@immutable
abstract class AddPromptResState {}

class AddPromptResInitial extends AddPromptResState {}
class AddPromptResLoading extends AddPromptResState{}
class AddPromptResSuccess extends AddPromptResState{
  String promptName;
  String resourceName;
  AddPromptResSuccess({required this.promptName, required this.resourceName});
}
class AddPromptResError extends AddPromptResState{
  String errorMessage;
  AddPromptResError({required this.errorMessage});
}

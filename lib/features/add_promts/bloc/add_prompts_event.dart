part of 'add_prompts_bloc.dart';

@immutable
abstract class AddPrompts {}

class LoadPrompts extends AddPrompts{}
class ChangeMediaType extends AddPrompts{
  final int whichSide;
  final String? MediaType;

  ChangeMediaType({required this.whichSide,this.MediaType});
}
class PickResource extends AddPrompts{
  final int ?whichSide;
  final String ? mediaUrl;
  PickResource({this.mediaUrl,this.whichSide});
}

class AddResource extends AddPrompts{
  final int ? whichSide;
  final String ? name;
  final int ? mediaUrl;
  final String ? resourceId;
  final String ? content;

  AddResource({this.mediaUrl,this.resourceId,this.name,this.whichSide,this.content});
}

class AddPromptEvent extends AddPrompts{
  final String ? name;
  final String ? resourceId;
  AddPromptEvent({this.resourceId,this.name});
}

class ResetFileUploadStatus extends AddPrompts{
  ResetFileUploadStatus();
}


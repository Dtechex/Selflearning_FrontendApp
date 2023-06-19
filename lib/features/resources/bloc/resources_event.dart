part of 'resources_bloc.dart';

@immutable
abstract class ResourcesEvent {}

class LoadResourcesEvent extends ResourcesEvent{
  final String rootId;
  final String mediaType;

  LoadResourcesEvent({required this.rootId,required this.mediaType});
}
class DeleteResourcesEvent extends ResourcesEvent{
  final String rootId;

  DeleteResourcesEvent({required this.rootId});
}

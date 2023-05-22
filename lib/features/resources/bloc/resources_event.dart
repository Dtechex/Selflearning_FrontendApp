part of 'resources_bloc.dart';

@immutable
abstract class ResourcesEvent {}

class LoadResourcesEvent extends ResourcesEvent{
  final String rootId;

  LoadResourcesEvent({required this.rootId});
}

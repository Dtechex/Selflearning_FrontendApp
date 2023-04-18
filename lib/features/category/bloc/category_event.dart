part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class CategoryLoadEvent extends CategoryEvent{}

class SubCategoryLoadEvent extends CategoryEvent{
  final String? rootId;

  SubCategoryLoadEvent({this.rootId});
}





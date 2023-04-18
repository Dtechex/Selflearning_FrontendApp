part of 'category_bloc.dart';


abstract class SubCategoryEvent {}

class CategoryLoadEvent extends SubCategoryEvent{}

class SubCategoryLoadEvent extends SubCategoryEvent{
  final String? rootId;

  SubCategoryLoadEvent({this.rootId});
}





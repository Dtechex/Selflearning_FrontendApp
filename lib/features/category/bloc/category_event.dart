part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class CategoryLoadEvent extends CategoryEvent{}
class CategoryImportEvent extends CategoryEvent{
  String? dropDownValue;
  CategoryImportEvent({this.dropDownValue});
}


class SubCategoryLoadEvent extends CategoryEvent{
  final String? rootId;
  SubCategoryLoadEvent({this.rootId});
}





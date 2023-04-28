part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class CategoryImportEvent extends CategoryEvent{
  String? dropDownValue;
  CategoryImportEvent({this.dropDownValue});
}


class CategoryLoadEvent extends CategoryEvent{
  final String? rootId;
  CategoryLoadEvent({this.rootId});
}





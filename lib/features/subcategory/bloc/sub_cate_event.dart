import 'package:self_learning_app/features/subcategory/model/sub_cate_model.dart';

abstract class SubCategoryEvent {}

class SubCategoryLoadEvent extends SubCategoryEvent{
  final String? rootId;
  SubCategoryLoadEvent({this.rootId});
}



class SubCateChangeDropValueEvent extends SubCategoryEvent {
  final List<SubCategoryModel>? list;
  final String? subCateId;
  SubCateChangeDropValueEvent({this.subCateId,this.list});
}




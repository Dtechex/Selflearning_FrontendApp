import 'package:flutter/cupertino.dart';
import 'package:self_learning_app/features/subcategory/sub_cate_model.dart';

@immutable
abstract class SubCategoryState {}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategoryModel> cateList;

  SubCategoryLoaded({required this.cateList});
}

class SubCategoryFailed extends SubCategoryState {
  final String errorText;

  SubCategoryFailed({required this.errorText});
}

class SubCategoryAdded extends SubCategoryState {}

class SubCategoryColor extends SubCategoryState {
  final Color cateBgColor;

  SubCategoryColor({required this.cateBgColor});
}


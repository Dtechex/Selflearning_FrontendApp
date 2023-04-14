import 'package:flutter/cupertino.dart';

import '../data/model/category_model.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Record> cateList;

  CategoryLoaded({required this.cateList});
}

class CategoryFailed extends CategoryState {
  final String errorText;

  CategoryFailed({required this.errorText});
}

import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';

import 'package:self_learning_app/features/category/data/repo/category_repo.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryLoadEvent, SubCategoryState> {
  SubCategoryBloc() : super(SubCategoryLoading()) {
    on<SubCategoryLoadEvent>(_onGetSubCategoryList);
  }

  void _onGetSubCategoryList(
      SubCategoryLoadEvent event, Emitter<SubCategoryState> emit) async {
    emit(SubCategoryLoading());
    try {
      await CategoryRepo.getAllSubCategory(event.rootId).then((value) {
        emit(SubCategoryLoaded(cateList: value));
      });
    } catch (e) {
      print(e);
      emit(SubCategoryFailed(errorText: 'Oops Something went wrong'));
    }
  }
}

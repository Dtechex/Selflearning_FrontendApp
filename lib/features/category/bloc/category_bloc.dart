import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/category/data/repo/category_repo.dart';
import 'category_state.dart';
part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoading()) {
    on<CategoryLoadEvent>(_onGetCategoryList);
    on<CategoryImportEvent>(_oncategoryImportEvent);
  //  on<SubCategoryLoadEvent>(_onGetSubCategoryList);

  }

  void _onGetCategoryList(
      CategoryLoadEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      await CategoryRepo.getAllCategory().then((value) {
        emit(CategoryLoaded(cateList: value));
      });
    } catch (e) {
      print(e);
      emit(CategoryFailed(errorText: 'Oops Something went wrong'));
    }
  }


  void _oncategoryImportEvent(
      CategoryImportEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryChanged(category: event.dropDownValue!));
  }

  // void _onGetSubCategoryList(
  //     SubCategoryLoadEvent event, Emitter<CategoryState> emit) async {
  //   emit(CategoryLoading());
  //   try {
  //     await CategoryRepo.getAllSubCategory(event.rootId).then((value) {
  //       emit(SubCategoryLoaded(subCateList: value));
  //     });
  //   } catch (e) {
  //     print(e);
  //     emit(CategoryFailed(errorText: 'Oops Something went wrong'));
  //   }
  // }



}

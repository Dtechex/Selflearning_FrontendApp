import 'package:bloc/bloc.dart';
import 'package:self_learning_app/features/category/data/repo/category_repo.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_event.dart';
import 'package:self_learning_app/features/subcategory/bloc/sub_cate_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  SubCategoryBloc() : super(SubCategoryLoading()) {
    on<SubCategoryLoadEvent>(_onGetSubCategoryList);
   on<SubCateChangeDropValueEvent>(_onSubCateChangeDropValueEvent);
  }

  void _onGetSubCategoryList(
      SubCategoryLoadEvent event, Emitter<SubCategoryState> emit) async {
    emit(SubCategoryLoading());
    try {
      await CategoryRepo.getAllSubCategory(event.rootId).then((value) {
        emit(SubCategoryLoaded(cateList: value,ddValue: value.isNotEmpty?value.first.sId:''));
      });
    } catch (e) {
      print(e);
      emit(SubCategoryFailed(errorText: 'Oops Something went wrong'));
    }
  }

  void _onSubCateChangeDropValueEvent(
      SubCateChangeDropValueEvent event, Emitter<SubCategoryState> emit) async {
    emit(SubCategoryLoaded(cateList: event.list!,ddValue: event.subCateId));
  }

}



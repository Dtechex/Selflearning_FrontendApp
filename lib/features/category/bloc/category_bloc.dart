import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/category/data/repo/category_repo.dart';

import 'category_state.dart';

part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryLoading()) {
    on<CategoryLoadEvent>(_onGetCategoryList);
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
}

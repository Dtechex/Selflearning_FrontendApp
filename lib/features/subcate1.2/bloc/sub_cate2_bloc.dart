
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_event.dart';
import 'package:self_learning_app/features/subcate1.2/bloc/sub_cate2_state.dart';

import '../repo/subcate2_repo.dart';


class SubCategory2Bloc extends Bloc<SubCategory2Event, SubCategory2State> {
  SubCategory2Bloc() : super(SubCategory2Loading()) {
    on<SubCategory2LoadEvent>(_onGetSubCategoryList);
  }

  void _onGetSubCategoryList(
      SubCategory2LoadEvent event, Emitter<SubCategory2State> emit) async {
    emit(SubCategory2Loading());
    try {
      await SubCategory2Repo.getAllCategory(event.rootId).then((value) => emit(SubCategory2Loaded(cateList: value)));
    } catch (e) {
      print(e);
      emit(SubCategory2Failed(errorText: 'Oops Something went wrong'));
    }
  }
}

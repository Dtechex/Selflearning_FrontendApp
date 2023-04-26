
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/subcate1.1/bloc/sub_cate1_event.dart';
import 'package:self_learning_app/subcate1.1/bloc/sub_cate1_state.dart';
import '../repo/subcate1_repo.dart';


class SubCategory1Bloc extends Bloc<SubCategory1Event, SubCategory1State> {
  SubCategory1Bloc() : super(SubCategory1Loading()) {
    on<SubCategory1LoadEvent>(_onGetSubCategoryList);
  }

  void _onGetSubCategoryList(
      SubCategory1LoadEvent event, Emitter<SubCategory1State> emit) async {
    emit(SubCategory1Loading());
    try {
      await SubCategory1Repo.getAllCategory(event.rootId).then((value) => emit(SubCategory1Loaded(cateList: value)));
    } catch (e) {
      print(e);
      emit(SubCategory1Failed(errorText: 'Oops Something went wrong'));
    }
  }
}

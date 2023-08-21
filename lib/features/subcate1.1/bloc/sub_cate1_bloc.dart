
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/subcate1.1/bloc/sub_cate1_event.dart';
import 'package:self_learning_app/features/subcate1.1/bloc/sub_cate1_state.dart';

import '../repo/subcate1_repo.dart';


class SubCategory1Bloc extends Bloc<SubCategory1Event, SubCategory1State> {
  SubCategory1Bloc() : super(SubCategory1Loading()) {
    on<SubCategory1LoadEvent>(_onGetSubCategoryList);
    on<SubCategory1LoadEmptyEvent>(_onSubCategory1LoadEmptyEvent);
    on<DDValueSubCategoryChanged>(_onDDValueSubCategoryChanged);
  }

  void _onGetSubCategoryList(SubCategory1LoadEvent event,
      Emitter<SubCategory1State> emit) async {
    emit(SubCategory1Loading());
    try {
      await SubCategory1Repo.getAllCategory(event.rootId).then((value) =>
          emit(SubCategory1Loaded(cateList: value)));
    } catch (e) {
      print(e);
      emit(SubCategory1Failed(errorText: 'Oops Something went wrong'));
    }
  }


  void _onSubCategory1LoadEmptyEvent(SubCategory1LoadEmptyEvent event,
      Emitter<SubCategory1State> emit) async {
    emit(SubCategory1Loaded(cateList: const []));
  }



  void _onDDValueSubCategoryChanged(DDValueSubCategoryChanged event,
      Emitter<SubCategory1State> emit) {
    emit(SubCategory1Loaded(cateList: event.cateList!, ddValue: event.ddValue));
  }
}
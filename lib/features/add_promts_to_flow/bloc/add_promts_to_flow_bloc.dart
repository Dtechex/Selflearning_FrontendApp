import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_learning_app/features/add_promts_to_flow/bloc/data/model/add_prompt_to_flow_model.dart';

import 'data/repo/add_prompts_to_flow_repo.dart';

part 'add_promts_to_flow_event.dart';
part 'add_promts_to_flow_state.dart';

class AddPromtsToFlowBloc extends Bloc<AddPromtsToFlowEvent, AddPromtsToFlowInitial> {
  AddPromtsToFlowBloc() : super(
      AddPromtsToFlowInitial(
        mainCategory: MainCategory.initial,
        subCategory: SubCategory.initial,
        subCategory1: SubCategory1.initial,
        subCategory2: SubCategory2.initial,
      )) {
    on<LoadMainCategoryData>((event, emit) {
      // TODO: implement event handler
      emit(state.copyWith(mainCategory: MainCategory.loading));
      /*AddPromptsToFlowRepo.getData(mainCatId: '', emitter: emit).then((value) {
        if
      })
      emit(state.copyWith(mainCategory: MainCategory.loadSuccess, mainCategoryData: ));*/
    });

    on<LoadSubCategoryData>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadSubCategory1Data>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadSubCategory2Data>((event, emit) {
      // TODO: implement event handler
    });
  }
}

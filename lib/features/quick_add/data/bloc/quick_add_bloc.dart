import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/quick_add/data/repo/model/quick_type_model.dart';
import 'package:self_learning_app/features/quick_add/data/repo/quick_add_repo.dart';

import '../repo/model/quick_type_prompt_model.dart';
import '../repo/quickPromptRepo.dart';

part 'quick_add_event.dart';

part 'quick_add_state.dart';

class QuickAddBloc extends Bloc<QuickAddEvent, QuickAddState> {
  QuickAddBloc() : super(QuickAddInitial()) {
    on<ButtonPressedEvent>(_onButtonPressed);
    on<LoadQuickTypeEvent>(_onLoadQuickTypes);
  }

  void _onButtonPressed(ButtonPressedEvent event,
      Emitter<QuickAddState> emit) async {
    emit(QuickAddLoadingState());
    try {
      await QuickAddRepo.quickAdd(
          title: event.title!, contentType: event.contentType).then((value) {
        if (value == 201) {
          emit(QuickAddLoadedState());
        } else {
          emit((QuickAddErrorState(message: "error")));
        }
      });
    } catch (e) {
      print('${e} this is error');
      emit((QuickAddErrorState(message: e.toString())));
    }
  }


  void _onLoadQuickTypes(LoadQuickTypeEvent event,
      Emitter<QuickAddState> emit) async {
    emit(QuickAddLoadingState());
    try {
      await QuickAddRepo.getAllQuickTypes().then((value) {
        print(value.data!.record!.records);
        print('valuessss');
        emit(QuickAddLoadedState(list: value));
      });
    } catch (e) {
      print(e);
      print('errorr');
      emit(QuickAddErrorState( message: e.toString(),));
    }
  }

}

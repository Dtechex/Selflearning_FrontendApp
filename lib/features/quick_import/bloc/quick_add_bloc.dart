import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../repo/model/quick_type_model.dart';
import '../repo/quick_add_repo.dart';

part 'quick_add_event.dart';

part 'quick_add_state.dart';

class QuickImportBloc extends Bloc<QuickImportEvent, QuickImportState> {
  QuickImportBloc() : super(QuickImportInitial()) {
    on<ButtonPressedEvent>(_onButtonPressed);

    on<ChangeDropValue>(_onChangeDropValue);
    on<LoadQuickTypeEvent>(_onLoadQuickTypes);
  }

  void _onLoadQuickTypes(
      LoadQuickTypeEvent event, Emitter<QuickImportState> emit) async {
    emit(QuickImportLoadingState());
    try {
      await QuickImportRepo.getAllCategory(rootId: event.rootId).then((cateList) {
        emit(QuickImportLoadedState(list: cateList,value: cateList.first.sId));
      });
    } catch (e) {
      emit((QuickImportErrorState()));
    }
  }

  void _onButtonPressed(
      ButtonPressedEvent event, Emitter<QuickImportState> emit) async {
    emit(QuickImportLoadingState());
    try {
      await QuickImportRepo.addCategory(title: event.title!,rootId: event.rootId).then((value)async {
        await QuickImportRepo.deletequickAdd(id: event.quickAddId!);
        if (value == 201) {
          emit(QuickImportSuccessfullyState());
        }
      });
    } catch (e) {
      emit((QuickImportErrorState()));
    }
  }


}




void _onChangeDropValue(
    ChangeDropValue event, Emitter<QuickImportState> emit) async {
  emit(QuickImportLoadedState(list: event.list,value: event.title,));
}
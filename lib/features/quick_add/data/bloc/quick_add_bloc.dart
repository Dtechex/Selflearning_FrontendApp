import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/quick_add/data/repo/model/quick_type_model.dart';
import 'package:self_learning_app/features/quick_add/data/repo/quick_add_repo.dart';

part 'quick_add_event.dart';

part 'quick_add_state.dart';

class QuickAddBloc extends Bloc<QuickAddEvent, QuickAddState> {
  QuickAddBloc() : super(QuickAddInitial()) {
    on<ButtonPressedEvent>(_onButtonPressed);
    on<LoadQuickTypeEvent>(_onLoadQuickTypes);
  }

  void _onButtonPressed(
      ButtonPressedEvent event, Emitter<QuickAddState> emit) async {
    emit(QuickAddLoadingState());
    try {
      await QuickAddRepo.quickAdd(title: event.title!).then((value) {
        if (value == 201) {
          emit(QuickAddLoadedState());
        } else {
          emit((QuickAddErrorState()));
        }
      });
    } catch (e) {
      print('${e} this is error');
      emit((QuickAddErrorState()));
    }
  }

  void _onLoadQuickTypes(
      LoadQuickTypeEvent event, Emitter<QuickAddState> emit) async {
    emit(QuickAddLoadingState());
    try {
      await QuickAddRepo.getAllQuickTypes().then((value) {
        emit(QuickAddLoadedState(list: value));
      });
    } catch (e) {
      emit((QuickAddErrorState()));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/promt/data/model/promt_model.dart';
import 'package:self_learning_app/promt/data/promt_repo.dart';

import '../data/model/promt_model.dart';
import '../data/model/promt_model.dart';
import '../data/model/promt_model.dart';
import '../data/model/promt_model.dart';

part 'promt_event.dart';
part 'promt_state.dart';

class PromtBloc extends Bloc<PromtEvent, PromtState> {
  PromtBloc() : super(PromtInitial()) {
    on<LoadPromtEvent>(_onLoadPromtEvent);
  }

  _onLoadPromtEvent(LoadPromtEvent event, Emitter<PromtState>emit)async{
    emit(PromtLoading());
     await PromtRepo.getPromts(promtId: event.promtId).then((value) {
       emit(PromtLoaded(promtModel: value));
     });

  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_res_prompt_event.dart';
part 'get_res_prompt_state.dart';

class GetResPromptBloc extends Bloc<GetResPromptEvent, GetResPromptState> {
  GetResPromptBloc() : super(GetResPromptInitial()) {
    on<HitResPromptEvent>(getResPrompt);
  }
  void getResPrompt(HitResPromptEvent event,
      Emitter<GetResPromptState> emit){
    emit(GetResPromptLoading());
    bool res = true;
    if(res==true){
      emit(GetResPromptSucess(success: "resource is get"));
    }


  }
}

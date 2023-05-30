import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/resources/data/rep/resources_repo.dart';
import 'package:self_learning_app/features/subcategory/model/resources_model.dart';

part 'resources_event.dart';
part 'resources_state.dart';

class ResourcesBloc extends Bloc<ResourcesEvent, ResourcesState> {
  ResourcesBloc() : super(ResourcesInitial()) {
    on<LoadResourcesEvent>(_onLoadResourcesEvent);
  }

  _onLoadResourcesEvent(
      LoadResourcesEvent event, Emitter<ResourcesState> emit) async {
    emit(ResourcesLoading());
    try {
     await  ResourcesRepo.getResources(rootId: event.rootId).then((value) {
        emit(ResourcesLoaded(allResourcesModel: value!));
      });
    } catch (e) {
      emit(ResourcesError());
    }
  }
}

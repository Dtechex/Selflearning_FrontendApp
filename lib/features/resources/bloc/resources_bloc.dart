import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'resources_event.dart';
part 'resources_state.dart';

class ResourcesBloc extends Bloc<ResourcesEvent, ResourcesState> {
  ResourcesBloc() : super(ResourcesInitial()) {
    on<ResourcesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

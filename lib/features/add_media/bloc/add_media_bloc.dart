import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:self_learning_app/features/add_media/repo/add_media_repo.dart';

part 'add_media_event.dart';
part 'add_media_state.dart';

class AddMediaBloc extends Bloc<AddMediaEvent, AddMediaInitial> {
  AddMediaBloc() : super(AddMediaInitial(apiState: ApiState.initial)) {
    on<ImagePickEvent>(_onImagePickEvent);
    on<SubmitButtonEvent>(_onSubmitButtonEvent);
    on<AudioPickEvent>(_onAudioPickEvent);
    on<VideoPickEvent>(_onVideoPickEvent);
    on<TextPickEvent>(_onTextPickEvent);
  }
  _onAudioPickEvent(AudioPickEvent event, Emitter<AddMediaInitial> emit) {
    emit(state.copyWith(result: event.audio));
  }

  _onImagePickEvent(ImagePickEvent event, Emitter<AddMediaInitial> emit) {
    emit(state.copyWith(file: event.image));
  }

  _onVideoPickEvent(VideoPickEvent event, Emitter<AddMediaInitial> emit) {
    emit(state.copyWith(
      result: event.video,
    ));
  }

  _onTextPickEvent(TextPickEvent event, Emitter<AddMediaInitial> emit) {
    emit(state.copyWith(name: event.title));
  }

  _onSubmitButtonEvent(SubmitButtonEvent event, Emitter<AddMediaInitial> emit)async {
    emit(state.copyWith(apiState: ApiState.submitting));
    try {
     await  AddMediaRepo.uploadFileToServer(imagePath: state.file!.path).then((value) {
        if (value != null) {
          emit(state.copyWith(apiState: ApiState.submitted));
        }
      });
    } catch (e) {
      emit(state.copyWith(apiState: ApiState.submitError));
    } finally {
      emit(state.copyWith(apiState: ApiState.initial));
    }
  }
}

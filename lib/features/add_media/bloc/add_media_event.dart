part of 'add_media_bloc.dart';

@immutable
abstract class AddMediaEvent {}

class ImagePickEvent extends AddMediaEvent{

  final XFile? image;
  ImagePickEvent({this.image});
}

class AudioPickEvent extends AddMediaEvent{
  final FilePickerResult? audio;
  AudioPickEvent({this.audio});
}

class VideoPickEvent extends AddMediaEvent{
  final FilePickerResult? video;
  VideoPickEvent({this.video});
}

class TextPickEvent extends AddMediaEvent{
  final String? title;
  TextPickEvent({this.title});
}

class SubmitButtonEvent extends AddMediaEvent{
  final String mediaType;

  // final FilePickerResult? media;
  // final XFile? image;
  final String? title;

  SubmitButtonEvent({this.title,required this.mediaType});
}
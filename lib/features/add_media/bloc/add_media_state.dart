part of 'add_media_bloc.dart';



enum ApiState {initial ,submitting,submitted,submitError,}

@immutable
abstract class AddMediaState {}

class AddMediaInitial extends AddMediaState {
  final ApiState apiState;
  final XFile? file;
  final String? name;
  final FilePickerResult? result;
  AddMediaInitial( {this.file, this.name, this.result,required this.apiState});

  AddMediaInitial copyWith(
      {XFile? file, String? name, FilePickerResult? result,ApiState? apiState}) {
    return AddMediaInitial(
      apiState: apiState??this.apiState,
        name: name ?? this.name,
        file: file ?? this.file,
        result: result ?? this.result);
  }
}

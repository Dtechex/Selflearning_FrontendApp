

part of 'create_flow_screen_bloc.dart';

abstract class CreateFlowEvent extends Equatable{

}

class AddFlow extends CreateFlowEvent {

  final bool showDialog;

  AddFlow({required this.showDialog});
  @override
  // TODO: implement props
  List<Object?> get props => [showDialog];

}

class CreateAndSaveFlow extends CreateFlowEvent {

  final String title;
  CreateAndSaveFlow({required this.title});
  @override
  // TODO: implement props
  List<Object?> get props => [title];

}


class LoadAllFlowEvent extends CreateFlowEvent {

  final String catID;
  LoadAllFlowEvent({required this.catID});
  @override
  // TODO: implement props
  List<Object?> get props => [catID];

}

part of 'create_flow_screen_bloc.dart';

enum APIStatus{successful, failed, initial, loading}
class CreateFlowState extends Equatable {

  final bool showAddDialog;
  final bool showLoading;
  final APIStatus apiStatus;
  final List<FlowModel>? flowList;

  CreateFlowState({
    required this.apiStatus,
    required this.showAddDialog,
    required this.showLoading,
    this.flowList,
  });

  CreateFlowState copyWith({bool? showAddDialog, bool? showLoading, APIStatus? apiStatus, List<FlowModel>? flowList}){
    return CreateFlowState(showAddDialog: showAddDialog ?? false, showLoading: showLoading ?? false, apiStatus: apiStatus ?? this.apiStatus, flowList: flowList ?? this.flowList);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [showAddDialog, showLoading];

}
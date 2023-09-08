
part of 'create_flow_screen_bloc.dart';

enum APIStatus{successful, failed, initial, loading}
abstract class CreateFlowState {


}

class FlowLoading extends CreateFlowState{

}

class LoadFailed extends CreateFlowState{

}

class LoadSuccess extends CreateFlowState{

  List<FlowModel> flowList;

  LoadSuccess(this.flowList);
}
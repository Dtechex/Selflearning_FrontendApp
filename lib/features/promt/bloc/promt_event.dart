part of 'promt_bloc.dart';

@immutable
abstract class PromtEvent {}
 class LoadPromtEvent extends PromtEvent {
 final String promtId;
 LoadPromtEvent({required this.promtId});

}

class AddPromptFlow extends PromtEvent {
 final AddFlowModel ?addFlowModel;
 AddPromptFlow({this.addFlowModel});
}

class ViewResourceEvent extends PromtEvent {
 final bool ? showResource;
 ViewResourceEvent({this.showResource});
}



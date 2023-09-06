part of 'add_promts_to_flow_bloc.dart';

abstract class AddPromtsToFlowEvent extends Equatable {
  const AddPromtsToFlowEvent();
}


class LoadMainCategoryData extends AddPromtsToFlowEvent{
  final String catId;

  LoadMainCategoryData({required this.catId});

  @override
  // TODO: implement props
  List<Object?> get props => [catId];

}
class LoadSubCategoryData extends AddPromtsToFlowEvent{
  final String catId;

  LoadSubCategoryData({required this.catId});

  @override
  // TODO: implement props
  List<Object?> get props => [catId];

}
class LoadSubCategory1Data extends AddPromtsToFlowEvent{
  final String catId;

  LoadSubCategory1Data({required this.catId});

  @override
  // TODO: implement props
  List<Object?> get props => [catId];

}
class LoadSubCategory2Data extends AddPromtsToFlowEvent{
  final String catId;

  LoadSubCategory2Data({required this.catId});

  @override
  // TODO: implement props
  List<Object?> get props => [catId];

}

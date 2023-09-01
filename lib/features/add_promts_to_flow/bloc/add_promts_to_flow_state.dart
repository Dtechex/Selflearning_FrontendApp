part of 'add_promts_to_flow_bloc.dart';

abstract class AddPromtsToFlowState extends Equatable {
  const AddPromtsToFlowState();
}

enum MainCategory{initial, loading, loadSuccess, loadFailed,}
enum SubCategory{initial, loading, loadSuccess, loadFailed,}
enum SubCategory1{initial, loading, loadSuccess, loadFailed,}
enum SubCategory2{initial, loading, loadSuccess, loadFailed,}

class AddPromtsToFlowInitial extends AddPromtsToFlowState {

  MainCategory mainCategory;
  SubCategory subCategory;
  SubCategory1 subCategory1;
  AddPromptToFlowModel? mainCategoryData;
  AddPromptToFlowModel? subCategoryData;
  AddPromptToFlowModel? subCategory1Data;
  AddPromptToFlowModel? subCategory2Data;
  SubCategory2 subCategory2;


  AddPromtsToFlowInitial({
    required this.mainCategory,
    required this.subCategory,
    required this.subCategory1,
    required this.subCategory2,
    this.subCategoryData,
    this.mainCategoryData,
    this.subCategory1Data,
    this.subCategory2Data});

  AddPromtsToFlowInitial copyWith({
    MainCategory? mainCategory,
    SubCategory? subCategory,
    SubCategory1? subCategory1,
    AddPromptToFlowModel? mainCategoryData,
    AddPromptToFlowModel? subCategoryData,
    AddPromptToFlowModel? subCategory1Data,
    AddPromptToFlowModel? subCategory2Data,
    SubCategory2? subCategory2,}){
    return AddPromtsToFlowInitial(
        mainCategory: mainCategory?? this.mainCategory,
        subCategory: subCategory?? this.subCategory,
        subCategory1: subCategory1 ?? this.subCategory1,
        subCategory2: subCategory2 ?? this.subCategory2,
      mainCategoryData: mainCategoryData ?? this.mainCategoryData,
      subCategoryData: subCategoryData ?? this.subCategoryData,
      subCategory1Data: subCategory1Data ?? this.subCategory1Data,
      subCategory2Data: subCategory2Data ?? this.subCategory2Data,
    );
  }

  @override
  List<Object> get props => [mainCategory, subCategory, subCategory1, subCategory2,];
}

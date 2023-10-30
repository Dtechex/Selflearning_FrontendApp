class AddDailogModel{
  String dailogName;
  String dailogId;
  String userId;

  AddDailogModel({required this.dailogName, required this.dailogId, required this.userId});



}

class AddResourceListModel{

  String resourceId;
  String resourceName;
  String resourceType;
  String resourceContent;

  AddResourceListModel({required this.resourceId, required this.resourceName, required this.resourceType, required this.resourceContent});

}
class AddPromptListModel{
  String promptId;
  String parentPromptId;
  String promptTitle;
  String promptSide1Content;
  String promptSide2Content;
  AddPromptListModel({required this.promptId, required this.parentPromptId, required this.promptTitle, required this.promptSide1Content,
  required this.promptSide2Content
  });

}
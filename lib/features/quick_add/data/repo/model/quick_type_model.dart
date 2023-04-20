class QuickTypeModel {
  String? sId;
  String? type;
  String? content;
  String? rootId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  QuickTypeModel(
      {this.sId,
        this.type,
        this.content,
        this.rootId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  QuickTypeModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    content = json['content'];
    rootId = json['rootId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['type'] = type;
    data['content'] = content;
    data['rootId'] = rootId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
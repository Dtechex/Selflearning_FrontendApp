class PromtModel {
  String? sId;
  String? name;
  String? resourceId;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PromtModel(
      {this.sId,
        this.name,
        this.resourceId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PromtModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    resourceId = json['resourceId'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['resourceId'] = this.resourceId;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
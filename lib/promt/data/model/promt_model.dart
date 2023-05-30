

class PromtModel {
  String? sId;
  String? type;
  String? content;
  String? rootId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PromtModel(
      {this.sId,
        this.type,
        this.content,
        this.rootId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PromtModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    content = json['content'];
    rootId = json['rootId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['content'] = this.content;
    data['rootId'] = this.rootId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

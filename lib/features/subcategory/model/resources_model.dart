class AllResourcesModel {
  String? message;
  Data? data;

  AllResourcesModel({this.message, this.data});

  AllResourcesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Record>? record;

  Data({this.record});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['record'] != null) {
      record = <Record>[];
      json['record'].forEach((v) {
        record!.add(new Record.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.record != null) {
      data['record'] = this.record!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Record {
  String? sId;
  String? type;
  String? content;
  String? rootId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Record(
      {this.sId,
        this.type,
        this.content,
        this.rootId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Record.fromJson(Map<String, dynamic> json) {
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

class JuzModel {
  bool? success;
  int? statusCode;
  String? message;
  List<Data>? data;

  JuzModel({this.success, this.statusCode, this.message, this.data});

  JuzModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? number;
  List<Verses>? verses;

  Data({this.id, this.number, this.verses});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    if (json['verses'] != null) {
      verses = <Verses>[];
      json['verses'].forEach((v) {
        verses!.add(new Verses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    if (this.verses != null) {
      data['verses'] = this.verses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verses {
  String? chapter;
  String? start;
  String? end;

  Verses({this.chapter, this.start, this.end});

  Verses.fromJson(Map<String, dynamic> json) {
    chapter = json['chapter'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapter'] = this.chapter;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

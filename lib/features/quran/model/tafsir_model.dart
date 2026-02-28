class TafsirModel {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<Data>? data;

  TafsirModel({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  TafsirModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
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
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Pagination({this.page, this.limit, this.total, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['total_page'] = this.totalPage;
    return data;
  }
}

class Data {
  String? startKey;
  String? endKey;
  String? content;

  Data({this.startKey, this.endKey, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    startKey = json['startKey'];
    endKey = json['endKey'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startKey'] = this.startKey;
    data['endKey'] = this.endKey;
    data['content'] = this.content;
    return data;
  }
}

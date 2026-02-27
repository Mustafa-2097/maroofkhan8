class DuaResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<DuaData>? data;

  DuaResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  DuaResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <DuaData>[];
      json['data'].forEach((v) {
        data!.add(DuaData.fromJson(v));
      });
    }
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
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPage'] = totalPage;
    return data;
  }
}

class DuaData {
  String? id;
  String? title;
  String? arabic;
  String? pronunciation;
  String? meaning;
  String? status;
  String? type;

  DuaData({
    this.id,
    this.title,
    this.arabic,
    this.pronunciation,
    this.meaning,
    this.status,
    this.type,
  });

  DuaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    arabic = json['arabic'];
    pronunciation = json['pronunciation'];
    meaning = json['meaning'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['arabic'] = arabic;
    data['pronunciation'] = pronunciation;
    data['meaning'] = meaning;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}

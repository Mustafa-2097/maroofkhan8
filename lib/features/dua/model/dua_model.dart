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
  String? name;
  String? nameArabic;
  String? description;
  String? translation;
  String? reference;

  DuaData({
    this.id,
    this.name,
    this.nameArabic,
    this.description,
    this.translation,
    this.reference,
  });

  DuaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameArabic = json['nameArabic'];
    description = json['description'];
    translation = json['translation'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameArabic'] = nameArabic;
    data['description'] = description;
    data['translation'] = translation;
    data['reference'] = reference;
    return data;
  }
}

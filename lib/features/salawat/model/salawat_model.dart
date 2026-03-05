class SalawatResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<SalawatData>? data;

  SalawatResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  SalawatResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <SalawatData>[];
      json['data'].forEach((v) {
        data!.add(SalawatData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
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

class SalawatData {
  String? id;
  String? title;
  String? arabic;
  String? translation;
  String? transliteration;
  String? audio;
  String? pronunciation;
  String? meaning;
  String? file;
  String? status;
  bool? isSaved;

  SalawatData({
    this.id,
    this.title,
    this.arabic,
    this.translation,
    this.transliteration,
    this.audio,
    this.pronunciation,
    this.meaning,
    this.file,
    this.status,
    this.isSaved,
  });

  SalawatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    arabic = json['arabic'];
    translation = json['translation'] ?? json['meaning'];
    transliteration = json['transliteration'] ?? json['pronunciation'];
    audio = json['audio'] ?? json['file'];
    pronunciation = json['pronunciation'];
    meaning = json['meaning'];
    file = json['file'];
    status = json['status'];
    isSaved = json['isSaved'] ?? json['saved'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['arabic'] = arabic;
    data['translation'] = translation;
    data['transliteration'] = transliteration;
    data['audio'] = audio;
    data['pronunciation'] = pronunciation;
    data['meaning'] = meaning;
    data['file'] = file;
    data['status'] = status;
    data['isSaved'] = isSaved;
    return data;
  }
}

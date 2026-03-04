class AudioResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<AudioData>? data;

  AudioResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  AudioResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json.containsKey('pagination')
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <AudioData>[];
      json['data'].forEach((v) {
        data!.add(AudioData.fromJson(v));
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

class AudioData {
  String? id;
  String? title;
  String? subtitle;
  String? file;
  String? category;
  String? createdAt;
  String? updatedAt;

  AudioData({
    this.id,
    this.title,
    this.subtitle,
    this.file,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  AudioData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    file = json['file'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['file'] = file;
    data['category'] = category;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

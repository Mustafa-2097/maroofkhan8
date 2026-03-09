class MeditationResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<MeditationData>? data;

  MeditationResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  MeditationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <MeditationData>[];
      json['data'].forEach((v) {
        data!.add(MeditationData.fromJson(v));
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

class SingleMeditationResponse {
  bool? success;
  int? statusCode;
  String? message;
  MeditationData? data;

  SingleMeditationResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  SingleMeditationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? MeditationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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

class MeditationData {
  String? id;
  String? title;
  String? subtitle;
  String? file;
  String? status;
  String? createdAt;
  String? updatedAt;

  MeditationData({
    this.id,
    this.title,
    this.subtitle,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  MeditationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    file = json['file'];
    status = json['status'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['file'] = file;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
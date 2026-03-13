class GuidedMeditationResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<GuidedMeditationData>? data;

  GuidedMeditationResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  GuidedMeditationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <GuidedMeditationData>[];
      json['data'].forEach((v) {
        data!.add(GuidedMeditationData.fromJson(v));
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

class SingleGuidedMeditationResponse {
  bool? success;
  int? statusCode;
  String? message;
  GuidedMeditationData? data;

  SingleGuidedMeditationResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  SingleGuidedMeditationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? GuidedMeditationData.fromJson(json['data'])
        : null;
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

class GuidedMeditationData {
  String? id;
  String? name;
  String? nameArabic;
  String? meaning;
  String? file;
  String? status;
  String? createdAt;
  String? updatedAt;

  GuidedMeditationData({
    this.id,
    this.name,
    this.nameArabic,
    this.meaning,
    this.file,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  GuidedMeditationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameArabic = json['nameArabic'];
    meaning = json['meaning'];
    file = json['file'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameArabic'] = nameArabic;
    data['meaning'] = meaning;
    data['file'] = file;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

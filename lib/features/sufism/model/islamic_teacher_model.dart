class IslamicTeacherResponse {
  bool? success;
  int? statusCode;
  String? message;
  Pagination? pagination;
  List<IslamicTeacherData>? data;

  IslamicTeacherResponse({
    this.success,
    this.statusCode,
    this.message,
    this.pagination,
    this.data,
  });

  IslamicTeacherResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <IslamicTeacherData>[];
      json['data'].forEach((v) {
        data!.add(IslamicTeacherData.fromJson(v));
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

class SingleIslamicTeacherResponse {
  bool? success;
  int? statusCode;
  String? message;
  IslamicTeacherData? data;

  SingleIslamicTeacherResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  SingleIslamicTeacherResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null
        ? IslamicTeacherData.fromJson(json['data'])
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

class IslamicTeacherData {
  String? id;
  String? title;
  String? subtitle;
  String? image;
  String? status;
  List<Teaching>? teachings;
  String? createdAt;
  String? updatedAt;

  IslamicTeacherData({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.status,
    this.teachings,
    this.createdAt,
    this.updatedAt,
  });

  IslamicTeacherData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
    status = json['status'];
    if (json['teachings'] != null) {
      teachings = <Teaching>[];
      json['teachings'].forEach((v) {
        teachings!.add(Teaching.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['image'] = image;
    data['status'] = status;
    if (teachings != null) {
      data['teachings'] = teachings!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Teaching {
  String? title;
  String? description;

  Teaching({this.title, this.description});

  Teaching.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
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

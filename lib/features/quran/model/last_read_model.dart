import 'dart:convert';

class LastReadResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<LastReadData>? data;

  LastReadResponse({this.success, this.statusCode, this.message, this.data});

  LastReadResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <LastReadData>[];
      json['data'].forEach((v) {
        if (v is Map<String, dynamic>) {
          data!.add(LastReadData.fromJson(v));
        } else if (v is String) {
          try {
            final decoded = jsonDecode(v);
            if (decoded is Map<String, dynamic>) {
              data!.add(LastReadData.fromJson(decoded));
            }
          } catch (_) {}
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastReadData {
  String? id;
  LastReadChapter? chapter;
  int? verse;
  CreatedAt? createdAt;

  LastReadData({this.id, this.chapter, this.verse, this.createdAt});

  LastReadData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    if (json['chapter'] != null) {
      if (json['chapter'] is Map<String, dynamic>) {
        chapter = LastReadChapter.fromJson(json['chapter']);
      } else {
        // Handle case where chapter is just an ID
        chapter = LastReadChapter(
          id: int.tryParse(json['chapter'].toString()),
          chapterNumber: int.tryParse(json['chapter'].toString()),
        );
      }
    }
    verse = json['verse'] is int
        ? json['verse']
        : int.tryParse(json['verse']?.toString() ?? "");

    if (json['createdAt'] != null &&
        json['createdAt'] is Map<String, dynamic>) {
      createdAt = CreatedAt.fromJson(json['createdAt']);
    } else {
      createdAt = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (chapter != null) {
      data['chapter'] = chapter!.toJson();
    }
    data['verse'] = verse;
    if (createdAt != null) {
      data['createdAt'] = createdAt!.toJson();
    }
    return data;
  }
}

class LastReadChapter {
  int? id;
  int? chapterNumber;
  String? name;
  String? nameComplex;
  String? nameArabic;
  String? nameTranslated;
  int? versesCount;
  String? revelationPlace;
  int? revelationOrder;

  LastReadChapter({
    this.id,
    this.chapterNumber,
    this.name,
    this.nameComplex,
    this.nameArabic,
    this.nameTranslated,
    this.versesCount,
    this.revelationPlace,
    this.revelationOrder,
  });

  LastReadChapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterNumber = json['chapterNumber'];
    name = json['name'];
    nameComplex = json['nameComplex'];
    nameArabic = json['nameArabic'];
    nameTranslated = json['nameTranslated'];
    versesCount = json['versesCount'];
    revelationPlace = json['revelationPlace'];
    revelationOrder = json['revelationOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chapterNumber'] = chapterNumber;
    data['name'] = name;
    data['nameComplex'] = nameComplex;
    data['nameArabic'] = nameArabic;
    data['nameTranslated'] = nameTranslated;
    data['versesCount'] = versesCount;
    data['revelationPlace'] = revelationPlace;
    data['revelationOrder'] = revelationOrder;
    return data;
  }
}

class CreatedAt {
  CreatedAt();

  CreatedAt.fromJson(dynamic json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

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
    if (json['data'] != null) {
      data = <LastReadData>[];
      json['data'].forEach((v) {
        data!.add(LastReadData.fromJson(v));
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
    id = json['id'];
    chapter = json['chapter'] != null
        ? LastReadChapter.fromJson(json['chapter'])
        : null;
    verse = json['verse'];
    createdAt = json['createdAt'] != null
        ? CreatedAt.fromJson(json['createdAt'])
        : null;
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

  CreatedAt.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class AudioResponse {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  AudioResponse({this.success, this.statusCode, this.message, this.data});

  AudioResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? url;
  String? format;
  int? size;
  List<Segments>? segments;

  Data({this.url, this.format, this.size, this.segments});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    format = json['format'];
    size = json['size'];
    if (json['segments'] != null) {
      segments = <Segments>[];
      json['segments'].forEach((v) {
        segments!.add(new Segments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['format'] = this.format;
    data['size'] = this.size;
    if (this.segments != null) {
      data['segments'] = this.segments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Segments {
  String? verseKey;
  int? timestampFrom;
  int? timestampTo;
  int? duration;

  Segments({
    this.verseKey,
    this.timestampFrom,
    this.timestampTo,
    this.duration,
  });

  Segments.fromJson(Map<String, dynamic> json) {
    verseKey = json['verse_key'];
    timestampFrom = json['timestamp_from'];
    timestampTo = json['timestamp_to'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verse_key'] = this.verseKey;
    data['timestamp_from'] = this.timestampFrom;
    data['timestamp_to'] = this.timestampTo;
    data['duration'] = this.duration;
    return data;
  }
}

class SurahModel {
  final int id;
  final String name;
  final String translatedName;
  final int versesCount;
  final String revelationPlace;

  SurahModel({
    required this.id,
    required this.name,
    required this.translatedName,
    required this.versesCount,
    required this.revelationPlace,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      translatedName: json['nameTranslated'] ?? json['translatedName'] ?? '',
      versesCount: json['versesCount'] is int
          ? json['versesCount']
          : int.tryParse(json['versesCount'].toString()) ?? 0,
      revelationPlace: json['revelationPlace'] ?? '',
    );
  }
}

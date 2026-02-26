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
      id: json['id'],
      name: json['name'],
      translatedName: json['nameTranslated'],
      versesCount: json['versesCount'],
      revelationPlace: json['revelationPlace'],
    );
  }
}
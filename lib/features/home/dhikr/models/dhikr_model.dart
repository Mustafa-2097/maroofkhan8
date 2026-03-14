class DhikrModel {
  final String id;
  final String arabic;
  final String pronunciation;
  final String meaning;
  final int count;
  final String file;

  DhikrModel({
    required this.id,
    required this.arabic,
    required this.pronunciation,
    required this.meaning,
    required this.count,
    required this.file,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['id'] ?? '',
      arabic: json['arabic'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      meaning: json['meaning'] ?? '',
      count: json['count'] ?? 33,
      file: json['file'] ?? '',
    );
  }
}

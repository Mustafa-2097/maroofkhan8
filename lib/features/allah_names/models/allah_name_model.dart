class AllahName {
  final String id;
  final String arabic;
  final String pronunciation;
  final String meaning;
  final String file;
  final bool isSaved;

  AllahName({
    required this.id,
    required this.arabic,
    required this.pronunciation,
    required this.meaning,
    required this.file,
    required this.isSaved,
  });

  factory AllahName.fromJson(Map<String, dynamic> json) {
    return AllahName(
      id: json['id'] ?? '',
      arabic: json['arabic'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      meaning: json['meaning'] ?? '',
      file: json['file'] ?? '',
      isSaved: json['isSaved'] ?? false,
    );
  }
}

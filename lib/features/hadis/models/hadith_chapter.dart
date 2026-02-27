class HadithChapter {
  final int id;
  final String name;
  final String number;

  HadithChapter({required this.id, required this.name, required this.number});

  factory HadithChapter.fromJson(Map<String, dynamic> json) {
    return HadithChapter(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      number: json['number']?.toString() ?? '',
    );
  }
}

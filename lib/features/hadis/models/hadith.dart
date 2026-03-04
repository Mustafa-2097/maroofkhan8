class Hadith {
  final int id;
  final String number;
  final String hadith;
  final String heading;
  bool isSaved;
  String? savedId;

  Hadith({
    required this.id,
    required this.number,
    required this.hadith,
    required this.heading,
    this.isSaved = false,
    this.savedId,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] ?? 0,
      number: json['number']?.toString() ?? '',
      hadith: json['hadith'] ?? '',
      heading: json['heading'] ?? '',
      isSaved: json['isSaved'] ?? false,
      savedId: json['savedId'],
    );
  }
}

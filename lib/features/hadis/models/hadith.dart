class Hadith {
  final int id;
  final String number;
  final String hadith;
  final String heading;

  Hadith({
    required this.id,
    required this.number,
    required this.hadith,
    required this.heading,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] ?? 0,
      number: json['number']?.toString() ?? '',
      hadith: json['hadith'] ?? '',
      heading: json['heading'] ?? '',
    );
  }
}

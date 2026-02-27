class HadithBook {
  final String id;
  final String name;
  final String writer;
  final String chapters;
  final String hadiths;

  HadithBook({
    required this.id,
    required this.name,
    required this.writer,
    required this.chapters,
    required this.hadiths,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      writer: json['writer'] ?? '',
      chapters: json['chapters'] ?? '0',
      hadiths: json['hadiths'] ?? '0',
    );
  }
}

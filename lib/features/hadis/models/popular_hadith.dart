class PopularHadith {
  final String id;
  final String hadith;
  final String reference;
  final String? book;
  final int? chapterNo;
  final int? hadithNo;

  PopularHadith({
    required this.id,
    required this.hadith,
    required this.reference,
    this.book,
    this.chapterNo,
    this.hadithNo,
  });

  factory PopularHadith.fromJson(Map<String, dynamic> json) {
    return PopularHadith(
      id: json['id'] ?? '',
      hadith: json['hadith'] ?? '',
      reference: json['reference'] ?? '',
      book: json['book'],
      chapterNo: json['chapterNo'],
      hadithNo: json['hadithNo'],
    );
  }
}

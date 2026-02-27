class LastReadHadith {
  final String? id;
  final String hadith;
  final String book;
  final String? chapterNo;
  final String? hadithNo;

  LastReadHadith({
    this.id,
    required this.hadith,
    required this.book,
    this.chapterNo,
    this.hadithNo,
  });

  factory LastReadHadith.fromJson(Map<String, dynamic> json) {
    return LastReadHadith(
      id: json['id'],
      hadith: json['hadith'] ?? '',
      book: json['book'] ?? '',
      chapterNo: json['chapterNo']?.toString(),
      hadithNo: json['hadithNo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hadith': hadith,
      'book': book,
      'chapterNo': chapterNo,
      'hadithNo': hadithNo,
    };
  }
}

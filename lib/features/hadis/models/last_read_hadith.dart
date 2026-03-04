class LastReadHadith {
  final String? id;
  final String hadith;
  final String book;
  final String? chapterNo;
  final String? hadithNo;
  bool isSaved;
  String? savedId;

  LastReadHadith({
    this.id,
    required this.hadith,
    required this.book,
    this.chapterNo,
    this.hadithNo,
    this.isSaved = false,
    this.savedId,
  });

  factory LastReadHadith.fromJson(Map<String, dynamic> json) {
    return LastReadHadith(
      id: json['id'],
      hadith: json['hadith'] ?? '',
      book: json['book'] ?? '',
      chapterNo: json['chapterNo']?.toString(),
      hadithNo: json['hadithNo']?.toString(),
      isSaved: json['isSaved'] ?? false,
      savedId: json['savedId'],
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

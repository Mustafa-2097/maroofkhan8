class IslamicNameModel {
  final String id;
  final String name;
  final String arabic;
  final String meaning;
  final String gender;
  final bool isSaved;

  IslamicNameModel({
    required this.id,
    required this.name,
    required this.arabic,
    required this.meaning,
    required this.gender,
    required this.isSaved,
  });

  factory IslamicNameModel.fromJson(Map<String, dynamic> json) {
    return IslamicNameModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      arabic: json['arabic'] ?? '',
      meaning: json['meaning'] ?? '',
      gender: json['gender'] ?? '',
      isSaved: json['isSaved'] ?? false,
    );
  }
}

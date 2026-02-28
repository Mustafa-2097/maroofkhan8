class AwliyaAllah {
  final String id;
  final String name;
  final String title;
  final String image;
  final String? birthPlace;
  final String? dateOfBirth;
  final String? dateOfDeath;
  final String? position;
  final String? institution;
  final String? works;
  final String? knownFor;
  final List<AwliyaContentItem>? teachings;
  final List<AwliyaContentItem>? karamats;
  final List<AwliyaContentItem>? quotes;

  AwliyaAllah({
    required this.id,
    required this.name,
    required this.title,
    required this.image,
    this.birthPlace,
    this.dateOfBirth,
    this.dateOfDeath,
    this.position,
    this.institution,
    this.works,
    this.knownFor,
    this.teachings,
    this.karamats,
    this.quotes,
  });

  factory AwliyaAllah.fromJson(Map<String, dynamic> json) {
    return AwliyaAllah(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      birthPlace: json['birthPlace'],
      dateOfBirth: json['dateOfBirth'],
      dateOfDeath: json['dateOfDeath'],
      position: json['position'],
      institution: json['institution'],
      works: json['works'],
      knownFor: json['knownFor'],
      teachings: json['teachings'] != null
          ? (json['teachings'] as List)
                .map((e) => AwliyaContentItem.fromJson(e))
                .toList()
          : null,
      karamats: json['karamats'] != null
          ? (json['karamats'] as List)
                .map((e) => AwliyaContentItem.fromJson(e))
                .toList()
          : null,
      quotes: json['quotes'] != null
          ? (json['quotes'] as List)
                .map((e) => AwliyaContentItem.fromJson(e))
                .toList()
          : null,
    );
  }
}

class AwliyaContentItem {
  final String title;
  final String description;

  AwliyaContentItem({required this.title, required this.description});

  factory AwliyaContentItem.fromJson(Map<String, dynamic> json) {
    return AwliyaContentItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

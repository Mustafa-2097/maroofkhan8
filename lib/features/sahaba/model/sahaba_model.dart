class Sahaba {
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
  final List<SahabaContentItem>? teachings;
  final List<SahabaContentItem>? quotes;

  Sahaba({
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
    this.quotes,
  });

  factory Sahaba.fromJson(Map<String, dynamic> json) {
    return Sahaba(
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
                .map((e) => SahabaContentItem.fromJson(e))
                .toList()
          : null,
      quotes: json['quotes'] != null
          ? (json['quotes'] as List)
                .map((e) => SahabaContentItem.fromJson(e))
                .toList()
          : null,
    );
  }
}

class SahabaContentItem {
  final String title;
  final String description;

  SahabaContentItem({required this.title, required this.description});

  factory SahabaContentItem.fromJson(Map<String, dynamic> json) {
    return SahabaContentItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

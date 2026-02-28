class AhleBait {
  final String id;
  final String name;
  final String image;
  final String relation;
  final String? dateOfBirth;
  final String? dateOfDeath;
  final String? position;
  final String? institution;
  final String? work;
  final String? knownFor;
  final String? story;
  final List<AhleBaitQuote>? quotes;

  AhleBait({
    required this.id,
    required this.name,
    required this.image,
    required this.relation,
    this.dateOfBirth,
    this.dateOfDeath,
    this.position,
    this.institution,
    this.work,
    this.knownFor,
    this.story,
    this.quotes,
  });

  factory AhleBait.fromJson(Map<String, dynamic> json) {
    return AhleBait(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      relation: json['relation'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      dateOfDeath: json['dateOfDeath'],
      position: json['position'],
      institution: json['institution'],
      work: json['work'],
      knownFor: json['knownFor'],
      story: json['story'],
      quotes: json['quotes'] != null
          ? (json['quotes'] as List)
                .map((q) => AhleBaitQuote.fromJson(q))
                .toList()
          : null,
    );
  }
}

class AhleBaitQuote {
  final String title;
  final String description;

  AhleBaitQuote({required this.title, required this.description});

  factory AhleBaitQuote.fromJson(Map<String, dynamic> json) {
    return AhleBaitQuote(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

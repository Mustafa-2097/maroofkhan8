class AhleBait {
  final String id;
  final String name;
  final String image;
  final String relation;

  AhleBait({
    required this.id,
    required this.name,
    required this.image,
    required this.relation,
  });

  factory AhleBait.fromJson(Map<String, dynamic> json) {
    return AhleBait(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      relation: json['relation'] ?? '',
    );
  }
}

class Sahaba {
  final String id;
  final String name;
  final String title;
  final String image;

  Sahaba({
    required this.id,
    required this.name,
    required this.title,
    required this.image,
  });

  factory Sahaba.fromJson(Map<String, dynamic> json) {
    return Sahaba(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

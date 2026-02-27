class AwliyaAllah {
  final String id;
  final String name;
  final String title;
  final String image;

  AwliyaAllah({
    required this.id,
    required this.name,
    required this.title,
    required this.image,
  });

  factory AwliyaAllah.fromJson(Map<String, dynamic> json) {
    return AwliyaAllah(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

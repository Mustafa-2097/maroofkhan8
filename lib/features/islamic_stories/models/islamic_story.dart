class IslamicStory {
  final String id;
  final String image;
  final String title;
  final String subtitle;

  IslamicStory({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  factory IslamicStory.fromJson(Map<String, dynamic> json) {
    return IslamicStory(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({required this.title, required this.subtitle, required this.image});
}

final List<OnboardingData> pages = [
  OnboardingData(
    title: "Learn the Rules, Save Your License",
    subtitle: "Learn the key mistakes that can cause your driving license to be cancelled.",
    image: "assets/images/onboarding_img01.png.png",
  ),
  OnboardingData(
    title: "Everything You Need in One Course",
    subtitle: "A simple 6 video course designed so you Don't Blow Your Licence for Drink or Drug Driving",
    image: "assets/images/onboarding_img02.png.png",
  ),
  OnboardingData(
    title: "Be a Responsible Driver",
    subtitle: "Make informed decisions and protect your driving privilege.",
    image: "assets/images/onboarding_img03.png.png",
  ),
];
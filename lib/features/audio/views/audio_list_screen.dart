import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_screen.dart';

class AudioListScreen extends StatefulWidget {
  final String category;
  const AudioListScreen({super.key, this.category = "Sufi Lectures"});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  final List<String> categories = [
    "Sufi Lectures",
    "Malfuzat",
    "Naats & Manqabats",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: HeaderSection(title: "Audio List"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          /// 1. Category Filter Chips (Fixed & Non-Scrollable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: categories.map((cat) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: cat != categories.last ? 8 : 0,
                    ),
                    child: _buildChip(cat, selectedCategory == cat, () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                /// 2. Featured Main Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                'assets/images/sheikh_image.png',
                                width: double.infinity,
                                height: 215,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trust in Allah',
                                    style: GoogleFonts.amiri(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1,
                                    ),
                                  ),
                                  const Text(
                                    'Shaykh’s Lecture',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text(
                                        '02:25',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            trackHeight: 3,
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                  enabledThumbRadius: 6,
                                                ),
                                            activeTrackColor: const Color(
                                              0xFF8D3C1F,
                                            ),
                                            inactiveTrackColor:
                                                Colors.grey.shade300,
                                            thumbColor: const Color(0xFF8D3C1F),
                                            overlayColor: const Color(
                                              0xFF8D3C1F,
                                            ).withOpacity(0.1),
                                          ),
                                          child: Slider(
                                            value: 2.25,
                                            max: 10.25,
                                            onChanged: (val) {},
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        '10:25',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildActionButton(
                                        icon: Icons.play_arrow_rounded,
                                        label: 'Listen',
                                        onPressed: () {},
                                      ),
                                      const SizedBox(width: 16),
                                      _buildActionButton(
                                        icon: Icons.file_download_outlined,
                                        label: 'Download (Premium)',
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// 3. Recent Lectures List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const AudioCard(),
                      const AudioCard(),
                      const AudioCard(),
                      const AudioCard(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8D3C1F) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8D3C1F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}

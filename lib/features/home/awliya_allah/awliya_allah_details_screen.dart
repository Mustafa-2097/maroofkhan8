import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/awliya_allah_model.dart';
import 'controllers/awliya_allah_controller.dart';

class AwliyaAllahDetailsScreen extends StatefulWidget {
  final AwliyaAllah awliya;
  const AwliyaAllahDetailsScreen({super.key, required this.awliya});

  @override
  State<AwliyaAllahDetailsScreen> createState() =>
      _AwliyaAllahDetailsScreenState();
}

class _AwliyaAllahDetailsScreenState extends State<AwliyaAllahDetailsScreen> {
  final Color primaryBrown = const Color(0xFF8D3C1F);
  final AwliyaAllahController controller = Get.find<AwliyaAllahController>();

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.selectedAwliya.value = null;
    controller.fetchAwliyaDetails(widget.awliya.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8D3C1F)),
            );
          }

          final awliya = controller.selectedAwliya.value ?? widget.awliya;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 2. Back Button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),

                // 3. Profile Image
                const SizedBox(height: 10),
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: awliya.image.isNotEmpty
                        ? NetworkImage(awliya.image)
                        : null,
                    backgroundColor: Colors.grey.shade200,
                    child: awliya.image.isEmpty
                        ? const Icon(Icons.person, size: 90, color: Colors.grey)
                        : null,
                  ),
                ),

                // 4. Names
                const SizedBox(height: 20),
                Text(
                  awliya.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  awliya.title,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                // 5. Tabs Row
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _tabButton("Biography", 0),
                      _tabButton("Teachings", 1),
                      _tabButton("Karamat", 2),
                      _tabButton("Quotes", 3),
                    ],
                  ),
                ),

                // 6. Section Title
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _getTabTitle(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                _buildTabBody(awliya),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getTabTitle() {
    switch (selectedTabIndex) {
      case 1:
        return "His Teaching";
      case 2:
        return "Verified Karamat";
      case 3:
        return "His Quotes";
      default:
        return "Biography";
    }
  }

  Widget _buildTabBody(AwliyaAllah awliya) {
    switch (selectedTabIndex) {
      case 1:
        return _contentListTab(awliya.teachings, "Teachings");
      case 2:
        return _contentListTab(awliya.karamats, "Karamat");
      case 3:
        return _contentListTab(awliya.quotes, "Quotes", isQuote: true);
      default:
        return _biographyTab(awliya);
    }
  }

  Widget _biographyTab(AwliyaAllah awliya) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow("Name :", awliya.name),
          _infoRow("Born :", awliya.dateOfBirth ?? "N/A"),
          _infoRow("Passed Away :", awliya.dateOfDeath ?? "N/A"),
          _infoRow("Position :", awliya.position ?? "N/A"),
          _infoRow("Institution :", awliya.institution ?? "N/A"),
          _infoRow("Works :", awliya.works ?? "N/A"),
          _infoRow("Known For :", awliya.knownFor ?? "N/A"),
        ],
      ),
    );
  }

  Widget _contentListTab(
    List<AwliyaContentItem>? items,
    String type, {
    bool isQuote = false,
  }) {
    if (items == null || items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Information about $type will be updated soon.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: items
          .map(
            (item) =>
                _actionCard(item.title, item.description, isQuote: isQuote),
          )
          .toList(),
    );
  }

  Widget _actionCard(String title, String body, {bool isQuote = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
              fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: primaryBrown,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Read More",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBrown : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/home/awliya_allah/awliya_allah_details_screen.dart';
import 'controllers/awliya_allah_controller.dart';
import 'models/awliya_allah_model.dart';

class AwliyaAllahListScreen extends StatelessWidget {
  const AwliyaAllahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AwliyaAllahController());
    const Color primaryBrown = Color(0xFF8D3C1F);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 1. Header Title
            Text(
              "Awliya Allah",
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(height: 10),
            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 3. Scrollable List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryBrown),
                  );
                }
                if (controller.awliyaList.isEmpty) {
                  return const Center(child: Text("No records found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  itemCount: controller.awliyaList.length,
                  itemBuilder: (context, index) {
                    final item = controller.awliyaList[index];
                    return AwliyaCard(awliya: item, buttonColor: primaryBrown);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class AwliyaCard extends StatelessWidget {
  final AwliyaAllah awliya;
  final Color buttonColor;

  const AwliyaCard({
    super.key,
    required this.awliya,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Get.to(() => AwliyaAllahDetailsScreen(awliya: awliya));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3), // vertical shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: awliya.image.isNotEmpty
                  ? NetworkImage(awliya.image)
                  : null,
              backgroundColor: Colors.grey.shade200,
              child: awliya.image.isEmpty
                  ? const Icon(Icons.person, size: 35, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    awliya.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    awliya.title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

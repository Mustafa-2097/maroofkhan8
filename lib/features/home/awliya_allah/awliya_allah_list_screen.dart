import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/home/awliya_allah/awliya_allah_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'controllers/awliya_allah_controller.dart';
import 'models/awliya_allah_model.dart';

class AwliyaAllahListScreen extends StatefulWidget {
  final bool hideBack;
  const AwliyaAllahListScreen({super.key, this.hideBack = false});

  @override
  State<AwliyaAllahListScreen> createState() => _AwliyaAllahListScreenState();
}

class _AwliyaAllahListScreenState extends State<AwliyaAllahListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AwliyaAllahController());
    const Color primaryBrown = Color(0xFF8D3C1F);

    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("awliya_allah_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Column(
        children: [
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
              child: TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: tr("search"),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
              if (controller.filteredAwliyaList.isEmpty) {
                return Center(child: Text(tr("no_records_found")));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                itemCount: controller.filteredAwliyaList.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredAwliyaList[index];
                  return AwliyaCard(awliya: item, buttonColor: primaryBrown);
                },
              );
            }),
          ),
        ],
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
    return GestureDetector(
      onTap: () {
        Get.to(() => AwliyaAllahDetailsScreen(awliya: awliya));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: awliya.image.isNotEmpty
                  ? NetworkImage(awliya.image)
                  : null,
              backgroundColor: Colors.grey.shade200,
              child: awliya.image.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    awliya.title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

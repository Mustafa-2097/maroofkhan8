import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/name_list_controller.dart';

class NamesListScreen extends StatelessWidget {
  final String pageTitle;
  final NameRepository repository;
  final bool useHeartIcon;
  const NamesListScreen({super.key, required this.pageTitle, required this.repository, required this.useHeartIcon});

  @override
  Widget build(BuildContext context) {
    // Unique tag for the controller since the same page is used for Save & Favorite
    final controller = Get.put(NamesListController(repository), tag: pageTitle);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          pageTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (controller.names.isEmpty) {
          return Center(
            child: Text("No items found", style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24), // Match your standard padding
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.1, // Adjusted for better text fit
          ),
          itemCount: controller.names.length,
          itemBuilder: (context, index) {
            return NameCard(
              nameData: controller.names[index],
              isFavoriteMode: useHeartIcon,
            );
          },
        );
      }),
    );
  }
}


class NameCard extends StatelessWidget {
  final AllahName nameData;
  final bool isFavoriteMode;

  const NameCard({super.key, required this.nameData, required this.isFavoriteMode});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Matches your Toggle/Status box style
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: 1,
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isFavoriteMode ? Icons.favorite : Icons.bookmark,
                color: Theme.of(context).colorScheme.primary, // Brand color (Brown/Orange)
                size: 20.r,
              ),
              // Use your Amiri font logic through headlineSmall/Medium
              Text(
                nameData.arabic,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.sp,
                ),
              ),
              Icon(
                  Icons.volume_up_outlined,
                  color: Theme.of(context).disabledColor,
                  size: 18.r
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            nameData.transliteration,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nameData.meaning,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

// The "Contract": Any repository must have a fetchNames method
abstract class NameRepository {
  Future<List<AllahName>> fetchNames();
}

// Version for the "SAVE" Page
class SaveRepository implements NameRepository {
  @override
  Future<List<AllahName>> fetchNames() async {
    // In the future, this is where your API code goes:
    // var response = await http.get('api/saved');
    await Future.delayed(const Duration(seconds: 1)); // Simulating network delay
    return [
      AllahName(arabic: "الرَّحْمَنُ", transliteration: "Ar-Rahman", meaning: "The Most Merciful"),
      AllahName(arabic: "الْمَلِكُ", transliteration: "Al-Malik", meaning: "The King, Absolute Owner"),
    ];
  }
}

// Version for the "FAVORITE" Page
class FavoriteRepository implements NameRepository {
  @override
  Future<List<AllahName>> fetchNames() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AllahName(arabic: "الرَّحِيمُ", transliteration: "Ar-Rahim", meaning: "The Most Compassionate"),
      AllahName(arabic: "الْقُدُّوسُ", transliteration: "Al-Quddus", meaning: "The Most Pure"),
    ];
  }
}

class AllahName {
  final String arabic;
  final String transliteration;
  final String meaning;

  AllahName({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });
}
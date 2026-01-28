import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NamesListScreen extends StatelessWidget {
  final String pageTitle;
  final NameRepository repository;
  final bool useHeartIcon;

  const NamesListScreen({
    super.key,
    required this.pageTitle,
    required this.repository,
    required this.useHeartIcon
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(pageTitle, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: FutureBuilder<List<AllahName>>(
        future: repository.fetchNames(), // Calls the API logic
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading names"));
          }

          final names = snapshot.data ?? [];

          return GridView.builder(
            padding: EdgeInsets.all(20.r),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 1.5,
            ),
            itemCount: names.length,
            itemBuilder: (context, index) {
              return NameCard(
                nameData: names[index],
                isFavoriteMode: useHeartIcon,
              );
            },
          );
        },
      ),
    );
  }
}


class NameCard extends StatelessWidget {
  final AllahName nameData;
  final bool isFavoriteMode;

  const NameCard({super.key, required this.nameData, required this.isFavoriteMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isFavoriteMode ? Icons.favorite : Icons.bookmark_border,
                color: const Color(0xFF8B4513),
                size: 22.r,
              ),
              Text(nameData.arabic, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              Icon(Icons.volume_up_outlined, color: Colors.grey.shade400, size: 18.r),
            ],
          ),
          SizedBox(height: 10.h),
          Text(nameData.transliteration, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          Text(
            nameData.meaning,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
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
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../model/surah_model.dart';
import '../model/juz_model.dart';
import '../model/last_read_model.dart';
import '../../../core/offline_storage/shared_pref.dart';

class QuranController extends GetxController {
  var surahList = <SurahModel>[].obs;
  var isLoading = false.obs;
  var juzList = <Data>[].obs;
  var isJuzLoading = false.obs;
  var lastReadList = <LastReadData>[].obs;
  var isLastReadLoading = false.obs;

  // Dummy data for fallback
  final List<SurahModel> dummySurahs = [
    SurahModel(
      id: 1,
      name: "Al-Fatihah",
      translatedName: "The Opener",
      versesCount: 7,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 2,
      name: "Al-Baqarah",
      translatedName: "The Cow",
      versesCount: 286,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 3,
      name: "Ali 'Imran",
      translatedName: "Family of Imran",
      versesCount: 200,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 4,
      name: "An-Nisa",
      translatedName: "The Women",
      versesCount: 176,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 5,
      name: "Al-Ma'idah",
      translatedName: "The Table Spread",
      versesCount: 120,
      revelationPlace: "MADINAH",
    ),
    SurahModel(
      id: 6,
      name: "Al-An'am",
      translatedName: "The Cattle",
      versesCount: 165,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 7,
      name: "Al-A'raf",
      translatedName: "The Heights",
      versesCount: 206,
      revelationPlace: "MAKKAH",
    ),
    SurahModel(
      id: 8,
      name: "Al-Anfal",
      translatedName: "The Spoils of War",
      versesCount: 75,
      revelationPlace: "MADINAH",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data only for surahs
    surahList.assignAll(dummySurahs);
    fetchSurahs();
    fetchJuzs();
    fetchLastRead();
  }

  Future<void> fetchSurahs() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();
      print("DEBUG: Fetching Surahs... Token present: ${token != null}");

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      print("DEBUG: Sending Headers: $headers");

      final url = Uri.parse(ApiEndpoints.Surah);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Status Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        dynamic surahData = decoded['data'];
        if (surahData != null) {
          List<dynamic> chapters;
          if (surahData is List) {
            chapters = surahData;
          } else if (surahData is Map && surahData['chapters'] is List) {
            chapters = surahData['chapters'];
          } else {
            return;
          }
          surahList.value = chapters
              .map((json) => SurahModel.fromJson(json))
              .toList();
        }
      } else {
        print("DEBUG: API rejected request with status ${response.statusCode}");
      }
    } catch (e) {
      // Keep dummy data if fetch fails
      print("Error fetching surahs, using fallback: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJuzs() async {
    try {
      isJuzLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.Juz);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        dynamic juzData = decoded['data'];
        if (juzData != null && juzData is List) {
          juzList.value = juzData.map((json) => Data.fromJson(json)).toList();
        }
      } else {
        print(
          "DEBUG: Juz API rejected request with status ${response.statusCode}",
        );
        // juzList remains empty as per requirement
        juzList.clear();
      }
    } catch (e) {
      print("Error fetching juzs: $e");
      // juzList remains empty as per requirement
      juzList.clear();
    } finally {
      isJuzLoading.value = false;
    }
  }

  Future<void> fetchLastRead() async {
    try {
      isLastReadLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.lastRead);
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      print("DEBUG: Last Read Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        dynamic lastReadData = decoded['data'];
        if (lastReadData != null && lastReadData is List) {
          lastReadList.value = lastReadData
              .map((json) => LastReadData.fromJson(json))
              .toList();
        }
      } else {
        print(
          "DEBUG: Last Read API rejected request with status ${response.statusCode}",
        );
        lastReadList.clear();
      }
    } catch (e) {
      print("Error fetching last read: $e");
      lastReadList.clear();
    } finally {
      isLastReadLoading.value = false;
    }
  }
}

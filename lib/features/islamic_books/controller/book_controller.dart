import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/book_model.dart';

class BookController extends GetxController {
  var isLoading = false.obs;
  var bookList = <BookData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.books);
      final response = await http.get(url, headers: headers);

      print("DEBUG: Books Status Code: ${response.statusCode}");
      print("DEBUG: Books Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final bookRes = BookResponse.fromJson(decoded);
        if (bookRes.data != null) {
          bookList.value = bookRes.data!;
        }
      }
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

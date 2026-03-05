import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/book_model.dart';

class BookController extends GetxController {
  var isLoading = false.obs;
  var bookList = <BookData>[].obs;
  var searchQuery = ''.obs;

  List<BookData> get filteredBookList {
    if (searchQuery.value.isEmpty) {
      return bookList;
    }
    return bookList.where((book) {
      final title = book.title?.toLowerCase() ?? '';
      final subtitle = book.subtitle?.toLowerCase() ?? '';
      final query = searchQuery.value.toLowerCase();
      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.books);

      if (response['success'] == true) {
        final bookRes = BookResponse.fromJson(response);
        if (bookRes.data != null) {
          bookList.value = bookRes.data!;
        }
      }
    } catch (e) {
      debugPrint("Error fetching books: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

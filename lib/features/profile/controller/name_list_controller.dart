import 'package:get/get.dart';
import '../view/pages/save.dart';

class NamesListController extends GetxController {
  final NameRepository repository;
  NamesListController(this.repository);

  var isLoading = true.obs;
  var names = <AllahName>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      var result = await repository.fetchNames();
      names.assignAll(result);
    } finally {
      isLoading(false);
    }
  }
}
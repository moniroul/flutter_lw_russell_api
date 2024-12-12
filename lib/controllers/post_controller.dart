import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      isLoading.value = true;
      final data = await apiService.fetchPosts();
      posts.value = data.map((item) => Post.fromJson(item)).toList();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      isLoading(false);
    }
  }
}

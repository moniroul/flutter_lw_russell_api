import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  final isUpdating = false.obs;
  final isUpdateId = 0.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void onInit() async {
    super.onInit();
  }

  fetchPosts() async {
    try {
      isLoading.value = true;
      final data = await apiService.fetchPosts();
      List<dynamic> alldata = data['data'];
      posts.value = alldata.map((item) => Post.fromJson(item)).toList();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      isLoading(false);
    }
  }

  noteAddfun(title, note) async {
    isLoading.value = true;

    var res = await apiService.noteAdd(title, note);

    if (res['id'] != null) {
      await fetchPosts();
      print("Note add succes");
    }
    isLoading.value = false;
  }

  noteUpdatefun(title, note, id) async {
    isLoading.value = true;

    var res = await apiService.noteUpdate(title, note, id);

    if (res['id'] != null) {
      await fetchPosts();
      titleController.clear();
      noteController.clear();
      isUpdateId.value = 0;
      isUpdating.value = false;
      print("Note add succes");
    }

    isLoading.value = false;
  }

  DeleteNote(id) async {
    isLoading.value = true;

    var res = await apiService.DeletePosts(id);

    if (res['status'] != null) {
      await fetchPosts();
      print("Note delete ${res['status']}");
    }
    isLoading.value = false;
  }
}

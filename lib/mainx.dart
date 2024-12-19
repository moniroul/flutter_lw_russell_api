import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lw_russell_api/controllers/post_controller.dart';
import 'package:flutter_lw_russell_api/models/post_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  Get.put(PostController());

  runApp(MaterialApp(
    home: Main(),
  ));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final postController = Get.find<PostController>();

  Future<Map<String, String>> bearerHeaderInfo() async {
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async {
      var res = await http.get(
          Uri.parse('https://lwr.playtunemusic.com/api/notes'),
          headers: await bearerHeaderInfo());
      print(res.statusCode);
      print(res.body);
      print(json.decode(res.body)['state']);
      print(json.decode(res.body)['data']);
     var posts =  Post.fromJson(json.decode(res.body)['data'][0]);
     print(posts.title);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Hello Flutter"),
    ));
  }
}

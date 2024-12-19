import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controllers/post_controller.dart';

void main() {
  Get.put(PostController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final postController = Get.find<PostController>();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () async {
      await postController.fetchPosts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX REST API Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostListScreen(),
    );
  }
}

class PostListScreen extends StatelessWidget {
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (postController.posts.isEmpty) {
          return Center(child: Text('No Posts Found'));
        }
        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            final post = postController.posts[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text("${post.id} - ${post.title}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(post.note),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        postController.isUpdateId.value = post.id;
                        postController.titleController.text = post.title;
                        postController.noteController.text = post.note;
                        postController.isUpdating.value = true;
                        await showDialog(
                          context: context,
                          builder: (context) => TaskAdd(),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.green,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () async {
                        await postController.DeleteNote(post.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(context: context, builder: (context) => TaskAdd());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Ctr = Get.find<PostController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: Ctr.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: Ctr.noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (Ctr.titleController.text.isNotEmpty &&
                        Ctr.noteController.text.isNotEmpty) {
                      print(Ctr.noteController.text);

                      if (Ctr.isUpdating.isTrue) {
                        await Ctr.noteUpdatefun(Ctr.titleController.text,
                            Ctr.noteController.text, Ctr.isUpdateId.value);
                      } else {
                        await Ctr.noteAddfun(
                            Ctr.titleController.text, Ctr.noteController.text);
                      }

                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      // Optional: Show validation error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Both fields are required'),
                        ),
                      );
                    }
                  },
                  child:
                      Text(Ctr.isUpdating.isTrue ? 'Update note' : 'Save note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

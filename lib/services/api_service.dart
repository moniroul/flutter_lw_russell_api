import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://lwr.playtunemusic.com/api';

  fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  noteAdd(title, note) async {
    final response = await http.post(Uri.parse('$baseUrl/notes/add'),
        body: {'title': title, 'note': note});
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add note');
    }
  }

  noteUpdate(title, note, id) async {
    final response = await http.post(Uri.parse('$baseUrl/notes-update/${id}'),
        body: {'title': title, 'note': note});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to Update note');
    }
  }

  DeletePosts(id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/${id}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

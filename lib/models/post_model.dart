class Post {
  final int id;
  final String title;
  final String note;

  Post({required this.id, required this.title, required this.note});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      note: json['note'],
    );
  }
}

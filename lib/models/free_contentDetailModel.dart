class FreeContentDetailModel {
  final int no, author_no;
  final String title, content, created_at, updated_at;
  final Map<String, dynamic> author;
  final List<dynamic> comments;

  FreeContentDetailModel({
    required this.no,
    required this.author_no,
    required this.title,
    required this.content,
    required this.created_at,
    required this.updated_at,
    required this.author,
    required this.comments,
  });

  FreeContentDetailModel.fromJson(Map<dynamic, dynamic> json)
      : no = json['no'],
        author_no = json['author_no'],
        title = json['title'],
        content = json['content'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        author = json['author'],
        comments = json['comments'];
}

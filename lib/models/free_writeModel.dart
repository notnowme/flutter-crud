class FreeWriteModel {
  final String title, content;

  FreeWriteModel({
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}

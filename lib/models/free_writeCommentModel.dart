class FreeWriteCommentModel {
  final String boardNo, content;

  FreeWriteCommentModel({
    required this.boardNo,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'boardNo': int.parse(boardNo),
      'content': content,
    };
  }
}

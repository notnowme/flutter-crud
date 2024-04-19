import 'package:crud/models/free_contentModel.dart';
import 'package:crud/screens/free/read/free_read.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BoardContent extends StatelessWidget {
  const BoardContent({super.key, required this.board});

  final FreeContentModel board;
  // 제목
  // 댓글 수
  // 날짜
  // 닉네임
  // 주소

  String formattingDateTime(DateTime date) {
    return DateFormat('yy.MM.dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(board.created_at);
    DateTime updatedAt = DateTime.parse(board.updated_at);
    String no = board.no.toString();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 1,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surface,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    context
                        .pushNamed(FreeReadWidget.routeName, pathParameters: {
                      'no': no,
                    });
                  },
                  child: Text(
                    board.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '[${board.comments.length}]',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text(
                  formattingDateTime(createdAt),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '|',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  board.author['nick'],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

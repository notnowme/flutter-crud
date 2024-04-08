import 'package:flutter/material.dart';

class QnaBoard extends StatelessWidget {
  const QnaBoard({super.key});

  static const String routeName = 'qna';
  static const String routePath = '/qna';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('질문 게시판'),
      ),
      body: const Center(
        child: Text('QNA'),
      ),
    );
  }
}

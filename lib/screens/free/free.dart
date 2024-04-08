import 'package:flutter/material.dart';

class FreeBoard extends StatelessWidget {
  const FreeBoard({super.key});

  static const String routeName = 'free';
  static const String routePath = '/free';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자유 게시판'),
      ),
      body: const Center(
        child: Text('FREE'),
      ),
    );
  }
}

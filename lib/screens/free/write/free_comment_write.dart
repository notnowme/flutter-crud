import 'package:crud/hooks/toast.dart';
import 'package:crud/providers/free_provider.dart';
import 'package:crud/screens/free/free.dart';
import 'package:crud/screens/free/read/free_read.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FreeCommentWriteWidget extends ConsumerWidget {
  const FreeCommentWriteWidget(this.no, {super.key});

  static const String routeName = 'freecmtwrite';
  static const String routePath = 'freecmtwrite/:no';
  final String? no;

  Future<void> _write(String content, String boardNo, WidgetRef ref,
      BuildContext context) async {
    ref.read(freeAsyncProvider.notifier).setCmtFormData(boardNo, content);
    final result = await ref.read(freeAsyncProvider.notifier).writeComment();
    if (result) {
      if (context.mounted) {
        ToastMessage.showToast(context, 'success', '작성했어요');
        context.goNamed(FreeReadWidget.routeName, pathParameters: {'no': no!});
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentController = TextEditingController();
    final contentFocus = FocusNode();

    const int maxLines = 20;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '댓글 쓰기',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        surfaceTintColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        shadowColor: Colors.grey[50],
        elevation: 3.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () async {
                final content = contentController.text;
                if (content.length < 4) {
                  ToastMessage.showToast(context, 'error', '내용은 4글자 이상 입력해야해요');
                  contentFocus.requestFocus();
                  return;
                }
                await _write(
                  content,
                  no!,
                  ref,
                  context,
                );
              },
              child: Text(
                '완료',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: maxLines * 30,
                child: TextField(
                  controller: contentController,
                  focusNode: contentFocus,
                  maxLines: maxLines,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                      hintText: '내용을 입력해 주세요',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.all(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

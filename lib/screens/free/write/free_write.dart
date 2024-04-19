import 'package:crud/hooks/toast.dart';
import 'package:crud/providers/free_provider.dart';
import 'package:crud/providers/refresh_provider.dart';
import 'package:crud/screens/free/free.dart';
import 'package:crud/screens/free/read/free_read.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FreeWriteWidget extends ConsumerWidget {
  const FreeWriteWidget({super.key});

  static const String routeName = 'freewrite';
  static const String routePath = 'freewrite';

  Future<void> _write(
      String title, String content, WidgetRef ref, BuildContext context) async {
    ref.read(freeAsyncProvider.notifier).setFormData(title, content);
    final result = await ref.read(freeAsyncProvider.notifier).write();
    if (result) {
      // 작성 성공
      if (context.mounted) {
        final data = ref.read(freeAsyncProvider.notifier).getData();
        ToastMessage.showToast(context, 'success', '작성했어요');
        ref.refresh(freeContentProvider);
        context.goNamed(
          FreeReadWidget.routeName,
          pathParameters: {
            'no': data!['data']['no'].toString(),
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final titleFocus = FocusNode();

    final contentController = TextEditingController();
    final contentFocus = FocusNode();

    const int maxLines = 20;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '글 쓰기',
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
                final title = titleController.text;
                final content = contentController.text;
                if (title.length < 4) {
                  ToastMessage.showToast(context, 'error', '제목은 4글자 이상 입력해야해요');
                  titleFocus.requestFocus();
                  return;
                }
                if (content.length < 4) {
                  ToastMessage.showToast(context, 'error', '내용은 4글자 이상 입력해야해요');
                  contentFocus.requestFocus();
                  return;
                }
                await _write(
                  title,
                  content,
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
                height: 50,
                child: TextField(
                  autofocus: true,
                  controller: titleController,
                  focusNode: titleFocus,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                  decoration: InputDecoration(
                      hintText: '제목을 입력해 주세요',
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
              const SizedBox(
                height: 20,
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

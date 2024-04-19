import 'dart:ui';

import 'package:crud/models/free_contentModel.dart';
import 'package:crud/providers/free_provider.dart';
import 'package:crud/providers/refresh_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/free/widgets/board_comment.dart';
import 'package:crud/screens/free/write/free_comment_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FreeReadWidget extends ConsumerStatefulWidget {
  const FreeReadWidget(this.no, {super.key});

  static const String routeName = 'freeread';
  static const String routePath = 'freeread/:no';
  final String? no;
  @override
  ConsumerState<FreeReadWidget> createState() => _FreeReadWidgetState();
}

class _FreeReadWidgetState extends ConsumerState<FreeReadWidget> {
  String formattingDateTime(DateTime date) {
    return DateFormat('yy.MM.dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String no = widget.no ?? '';
    final userData = ref.watch(userProvider);

    return ref.watch(freeOneContentProvider(no)).when(
      data: ((data) {
        if (data == null) {
          return const Center(
            child: Text(
              'no data',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );
        } else {
          DateTime createdAt = DateTime.parse(data.created_at);
          DateTime updatedAt = DateTime.parse(data.updated_at);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '자유 게시판',
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
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        data.content,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '[수정됨]',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formattingDateTime(createdAt),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '|',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        data.author['nick'],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.abc),
                                    color: Colors.black,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.abc),
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              data.content,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Column(
                    children: [
                      userData == null
                          ? const Center()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.pushReplacementNamed(
                                        FreeCommentWriteWidget.routeName,
                                        pathParameters: {
                                          'no': data.no.toString()
                                        });
                                  },
                                  icon: Icon(
                                    Icons.create_rounded,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                      // 댓글 리스트
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: data.comments.length,
                        // separatorBuilder: (context, index) {
                        //   return const SizedBox(
                        //     height: 1,
                        //   );
                        // },
                        itemBuilder: (context, index) {
                          var comment = data.comments[index];
                          return CommentWidget(
                            comment: comment,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }),
      error: (err, errStack) {
        return const Center(
          child: Text(
            'error',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

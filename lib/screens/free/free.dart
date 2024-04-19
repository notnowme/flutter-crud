import 'package:crud/models/free_contentModel.dart';
import 'package:crud/providers/free_provider.dart';
import 'package:crud/providers/refresh_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/free/widgets/board_content.dart';
import 'package:crud/screens/free/write/free_write.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FreeBoard extends ConsumerStatefulWidget {
  const FreeBoard({super.key});

  static const String routeName = 'free';
  static const String routePath = '/free';

  @override
  ConsumerState<FreeBoard> createState() => _FreeBoardState();
}

class _FreeBoardState extends ConsumerState<FreeBoard> {
  List<FreeContentModel>? boards = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print('자유 게시판 메인 dispose');
  }

  Future<void> getBoards() async {
    final result = ref.read(freeContentAsyncProvider.notifier).getBoards();
    result.then((value) {
      boards = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final freeContentList = ref.watch(freeContentProvider);
    final refresh = ref.watch(refreshProvier);

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
        actions: userData == null
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      context.pushNamed(FreeWriteWidget.routeName);
                    },
                    icon: const Icon(Icons.create_rounded),
                  ),
                ),
              ],
      ),
      body: freeContentList.when(
        data: ((data) {
          if (data == null) {
            return const Center(
              child: Text(
                'no data',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var board = data[index];
              return BoardContent(board: board);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 0,
              );
            },
          );
        }),
        error: (err, errStack) {
          print('error');
          return null;
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

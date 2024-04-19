import 'package:crud/providers/free_provider.dart';
import 'package:crud/providers/path_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/free/free.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/screens/profile/profile_main.dart';
import 'package:crud/screens/qna/qna.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNav extends ConsumerStatefulWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

Map<int, String> NAV_INDEX_MAPPER = {
  0: Home.routePath,
  1: FreeBoard.routePath,
  2: QnaBoard.routePath,
  3: Profile.routePath,
};

class _ScaffoldWithNavState extends ConsumerState<ScaffoldWithNav> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).init();
  }

  void onTapBottomNav(int index) {
    final hasAlreadyOnBranch = index == widget.navigationShell.currentIndex;
    final userData = ref.watch(userProvider);

    if (index == 3) {
      if (userData == null) {
        _showDialog();
        return;
      }
    }
    if (hasAlreadyOnBranch) {
      context.go(NAV_INDEX_MAPPER[index]!);
    } else {
      // context.push(NAV_INDEX_MAPPER[index]!);
      widget.navigationShell.goBranch(index);
    }
  }

  void _initNavIndex(BuildContext context) {
    final routeState = GoRouterState.of(context);
    late int index;
    for (final entry in NAV_INDEX_MAPPER.entries) {
      if (routeState.fullPath!.startsWith(entry.value)) {
        index = entry.key;
      }
    }
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initNavIndex(context);

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTapBottomNav,
        selectedItemColor: const Color(0xFF6200EE),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: '자유',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_rounded),
            label: '질문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: '프로필',
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            content: Builder(
              builder: (context) {
                return SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로그인 후 이용할 수 있어요1',
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pop();
                          ref
                              .read(pathProvider.notifier)
                              .updatePrevPath(Profile.routeName);
                          context.pushNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          '로그인 페이지로 이동',
                          style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

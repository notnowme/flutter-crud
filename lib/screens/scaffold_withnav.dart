import 'package:crud/screens/free/free.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/screens/profile/profile_main.dart';
import 'package:crud/screens/qna/qna.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNav extends StatefulWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

Map<int, String> NAV_INDEX_MAPPER = {
  0: Home.routePath,
  1: FreeBoard.routePath,
  2: QnaBoard.routePath,
  3: Profile.routePath,
};

class _ScaffoldWithNavState extends State<ScaffoldWithNav> {
  int currentIndex = 0;

  void onTapBottomNav(int index) {
    final hasAlreadyOnBranch = index == widget.navigationShell.currentIndex;
    if (hasAlreadyOnBranch) {
      context.go(NAV_INDEX_MAPPER[index]!);
    } else {
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
}

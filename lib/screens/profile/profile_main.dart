import 'package:crud/controllers/join_controller.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/providers/storage_provider.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/screens/profile/widgets/profile_boardInfo.dart';
import 'package:crud/screens/profile/widgets/profile_userInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  static const String routeName = 'profile';
  static const String routePath = '/profile';

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  String id = '';

  @override
  void initState() {
    getMe().then((value) {
      if (id.isEmpty) {
        _showDialog();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('abcafdsfasd');
  }

  void initData() async {
    await getMe();
  }

  Future<void> getMe() async {
    final storage = ref.read(secureStorageProvider);
    final data = await storage.read(key: 'id');
    if (data != null) {
      id = data;
    } else {
      id = '';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const UserInfoWidget(),
                const SizedBox(
                  height: 20,
                ),
                const BoardInfoWidget(
                  label: '자유 게시판',
                ),
                const SizedBox(
                  height: 20,
                ),
                const BoardInfoWidget(
                  label: '질문 게시판',
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    onPressed: () {
                      route.pushNamed(LoginScreen.routeName);
                    },
                    child: const Text('로그아웃'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    route.pushNamed(LoginScreen.routeName);
                  },
                  child: Text(
                    '탈퇴하기',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    final route = ref.watch(routesProvider);
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
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
                      '로그인 후 이용할 수 있어요',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.displayLarge?.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        route.goNamed(LoginScreen.routeName);
                        route.pop();
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
        );
      },
    );
  }
}

import 'package:crud/controllers/join_controller.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/providers/path_provider.dart';
import 'package:crud/providers/storage_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/screens/profile/widgets/profile_boardInfo.dart';
import 'package:crud/screens/profile/widgets/profile_logout.dart';
import 'package:crud/screens/profile/widgets/profile_userInfo.dart';
import 'package:crud/screens/profile/widgets/profile_withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    debugPrint('프로필 init');
    getMe().then((value) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('프로필 dispose');
  }

  void initData() async {
    await getMe();
  }

  Future<void> getMe() async {
    debugPrint('프로필 getMe');
    final storage = ref.read(secureStorageProvider);
    await ref.read(userProvider.notifier).init();
    final data = await storage.read(key: 'id');
    if (data != null) {
      id = data;
    } else {
      id = '';
      _showDialog();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final storage = ref.watch(secureStorageProvider);

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
      body: id.isEmpty
          ? const Center(
              child: Text('프로필'),
            )
          : SingleChildScrollView(
              child: Padding(
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                            onPressed: () {
                              _showLogoutDialog();
                            },
                            child: const Text('로그아웃'),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () {
                            if (mounted) {
                              showWithdrawDialog(context, ref);
                            }
                          },
                          child: Text(
                            '탈퇴하기',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showDialog() {
    final route = ref.watch(routesProvider);
    debugPrint('프로필의 다이어로그');
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
                        '로그인 후 이용할 수 있어요2',
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
                          context.pushNamed(LoginScreen.routeName).then((_) {
                            context.pop();
                            debugPrint('프로필 돌아올 때');
                          });
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

  void _showLogoutDialog() {
    final storage = ref.read(secureStorageProvider);

    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (__) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Builder(
            builder: (_) {
              return SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '로그아웃할까요?',
                      style: TextStyle(
                        color: Color(0xFF797979),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        TextButton(
                          onPressed: () async {
                            await storage.deleteAll();
                            if (mounted) {
                              ref.read(userProvider.notifier).clear();
                              context.pop();
                              context.goNamed(Home.routeName);
                            }
                          },
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              color: Color(0xFFCE3426),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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

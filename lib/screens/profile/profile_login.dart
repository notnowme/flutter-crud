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
    getMe().then((value) {});
    super.initState();
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
      _showDialog();
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '로그인 페이지',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
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
                        route.pushNamed(LoginScreen.routeName);
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

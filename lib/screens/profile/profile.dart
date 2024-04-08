import 'package:crud/controllers/join_controller.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  static const String routeName = 'profile';
  static const String routePath = '/profile';

  void join() async {
    final info = JoinModel(
      id: 'test101',
      nick: 'test101',
      password: '1234',
    ).toJson();

    final result = await JoinController().join(info);
    debugPrint(result.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            route.pushNamed(LoginScreen.routeName);
          },
          child: const Text('로그인 페이지'),
        ),
      ),
    );
  }
}

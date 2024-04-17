import 'package:crud/providers/storage_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showLogoutDialog(BuildContext context, WidgetRef ref) {
  final storage = ref.read(secureStorageProvider);
  showDialog(
    context: context,
    barrierDismissible: false,
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
                    '로그아웃할까요?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
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
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      TextButton(
                        onPressed: () async {
                          await storage.deleteAll();
                          ref.read(userProvider.notifier).clear();
                          context.pop();
                          context.goNamed(Home.routeName);
                        },
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
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

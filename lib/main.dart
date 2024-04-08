import 'package:crud/routes.dart';
import 'package:crud/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: "Pretendard",
        colorScheme: theme.colorScheme,
        textTheme: theme.textTheme,
      ),
      routerConfig: route,
      title: 'CRUD PRACTICE',
      debugShowCheckedModeBanner: false,
    );
  }
}

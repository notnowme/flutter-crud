import 'package:crud/routes.dart';
import 'package:crud/screens/profile/join_screen.dart';
import 'package:crud/widgets/render_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = 'login';
  static const String routePath = 'login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool formCheck = false;

  renderButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final isValided = formKey.currentState!.validate();
          if (isValided) {
            debugPrint('go login');
          } else {
            debugPrint('no');
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: formCheck
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        child: Text(
          '로그인',
          style: TextStyle(
            color: formCheck
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
          ),
        ),
      ),
    );
  }

  String id = '';

  late final TextEditingController idController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('aaa');
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '로그인',
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Form(
              key: formKey,
              onChanged: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    formCheck = true;
                  });
                } else {
                  setState(() {
                    formCheck = false;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          // height: 80,
                          child: RenderTextField(
                            label: '아이디',
                            controller: idController,
                            isAutoFocus: true,
                            isPassword: false,
                            validator: (value) {
                              if (value.length < 1) {
                                return '반드시 입력해야 해요';
                              }
                              if (value.length < 4) {
                                return '4글자 이상 입력해야 해요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  RenderTextField(
                    label: '비밀번호',
                    controller: passwordController,
                    isAutoFocus: false,
                    isPassword: true,
                    validator: (value) {
                      if (value.length < 1) {
                        return '반드시 입력해야 해요';
                      }
                      if (value.length < 8) {
                        return '8글자 이상 입력해야 해요';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            renderButton(),
            Row(
              children: [
                Text(
                  '아직 가입하지 않았나요?',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    route.pushNamed(JoinScreen.routeName).then((value) {
                      idController.clear();
                      passwordController.clear();
                    });
                  },
                  child: Text(
                    '가입하기',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

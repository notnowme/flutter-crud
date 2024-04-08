import 'package:crud/routes.dart';
import 'package:crud/screens/profile/join_screen.dart';
import 'package:crud/widgets/input_field.dart';
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
  final TextEditingController idTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  String idMsg = '아이디를 입력해 주세요', pwMsg = '비밀번호를 입력해 주세요';
  bool idCheck = false, pwCheck = false;

  void _handleIdReg(String id) {
    if (id.length < 4) {
      setState(() {
        idMsg = '4글자 이상 입력해야해요';
        idCheck = false;
      });
      return;
    }
    RegExp regex = RegExp(r'^[a-zA-Z0-9_\.]+$');
    if (!regex.hasMatch(id)) {
      setState(() {
        idMsg = '입력할 수 없는 문자가 있어요';
        idCheck = false;
      });
      return;
    }
    setState(() {
      idMsg = '';
      idCheck = true;
    });
  }

  void _handlePwReg(String pw) {
    if (pw.length < 7) {
      setState(() {
        pwMsg = '7글자 이상 입력해야해요';
        pwCheck = false;
      });
      return;
    }
    RegExp regex = RegExp(r'^[a-zA-Z0-9!@#$%^*+=-]+$');
    if (!regex.hasMatch(pw)) {
      setState(() {
        pwMsg = '입력할 수 없는 문자가 있어요';
        pwCheck = false;
      });
      return;
    }
    setState(() {
      pwMsg = '';
      pwCheck = true;
    });
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
              Column(
                children: [
                  Form(
                    onChanged: () {
                      _handleIdReg(idTextController.text);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          cat: '아이디',
                          controller: idTextController,
                          isAutoFocus: true,
                          isPassword: false,
                          isError: idCheck,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          idMsg,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    onChanged: () {
                      _handlePwReg(passwordTextController.text);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          cat: '비밀번호',
                          controller: passwordTextController,
                          isAutoFocus: false,
                          isPassword: true,
                          isError: pwCheck,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          pwMsg,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (idCheck && pwCheck) {
                          // 로그인 로직 작성하기...
                          debugPrint('ok!');
                          return;
                        }
                        return;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: idCheck && pwCheck
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize,
                          color: idCheck && pwCheck
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '아직 회원이 아니신가요?',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium?.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      TextButton(
                          onPressed: () {
                            route.pushNamed(JoinScreen.routeName);
                          },
                          child: Text(
                            '가입하기',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

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
  final _idFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  String idMsg = '아이디를 입력해 주세요', pwMsg = '비밀번호를 입력해 주세요';
  bool idCheck = false, pwCheck = false;

  String _handleIdReg(String id) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_\.]+$');
    if (!regex.hasMatch(id)) {
      return '입력할 수 없는 문자가 있어요';
    }
    if (id.length < 4) {
      return '4글자 이상 입력해야해요';
    }
    if (id.length > 20) {
      return '20글자까지 입력할 수 있어요';
    }
    return '';
  }

  String _handlePwReg(String pw) {
    if (pw.length < 7) {
      return '7글자 이상 입력해야해요';
    }
    RegExp regex = RegExp(r'^[a-zA-Z0-9!@#$%^*+=-]+$');
    if (!regex.hasMatch(pw)) {
      return '입력할 수 없는 문자가 있어요';
    }
    return '';
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
                    key: _idFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          cat: '아이디',
                          controller: idTextController,
                          isAutoFocus: true,
                          isPassword: false,
                          isError: idCheck,
                          validFunction: _handleIdReg,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _passwordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          cat: '비밀번호',
                          controller: passwordTextController,
                          isAutoFocus: false,
                          isPassword: true,
                          isError: pwCheck,
                          validFunction: _handlePwReg,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
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
                        final idCheck = _idFormKey.currentState!.validate();
                        final pwCheck =
                            _passwordFormKey.currentState!.validate();
                        if (idCheck && pwCheck) {
                          print('go login');
                        }
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

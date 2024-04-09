import 'package:crud/widgets/input_field.dart';
import 'package:crud/widgets/join_idField.dart';
import 'package:crud/widgets/join_nickField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinScreen extends ConsumerWidget {
  JoinScreen({super.key});

  static const String routeName = 'join';
  static const String routePath = '/join';
  final _passwordFormKey = GlobalKey<FormState>();
  final _passwordCheckFormKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nickController = TextEditingController();
    final TextEditingController passwordTextController =
        TextEditingController();
    final TextEditingController passwordCheckTextController =
        TextEditingController();
    bool pwCheck = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원 가입',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  IdFieldWidget(controller: idController),
                  const SizedBox(
                    height: 20,
                  ),
                  NickFieldWidget(controller: nickController),
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
                    height: 20,
                  ),
                  Form(
                    key: _passwordCheckFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputFieldWidget(
                          cat: '비밀번호 확인',
                          controller: passwordCheckTextController,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:crud/routes.dart';
import 'package:crud/screens/profile/join_screen.dart';
import 'package:crud/widgets/input_field.dart';
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
  final TextEditingController idTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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

  renderButton() {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          debugPrint('aaaaaa');
          formKey.currentState!.save();
        }
      },
      child: const Text(
        '테스트',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  renderValues() {
    return Column(
      children: [
        Text('id: $id',
            style: TextStyle(color: Colors.purple[300], fontSize: 18))
      ],
    );
  }

  String id = '';

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
            Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          child: RenderTextField(
                            label: '아이디',
                            onSaved: (value) {
                              setState(() {
                                id = value;
                              });
                            },
                            validator: (value) {
                              if(value.length < 1) return '반드시 입력해야 해요';
                              if(value.length < 4) return '4글자 이상 입력해야 해요';
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )
                        ),
                          child: const Text('확인',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                  RenderTextField(
                    label: '비밀번호',
                    onSaved: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            renderButton(),
            const SizedBox(
              height: 10,
            ),
            renderValues(),
          ],
        ),
      ),
    );
  }
}

import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/screens/profile/widgets/sign_idField.dart';
import 'package:crud/screens/profile/widgets/sign_nickField.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class JoinScreenWidget extends ConsumerStatefulWidget {
  const JoinScreenWidget({super.key});

  static const String routeName = 'join';
  static const String routePath = '/join';

  @override
  ConsumerState<JoinScreenWidget> createState() => _JoinScreenWidgetState();
}

class _JoinScreenWidgetState extends ConsumerState<JoinScreenWidget> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  final GlobalKey<FormState> idFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> nickFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  late bool isAllValid = false;

  Future<void> _signUp() async {
    final id = await ref.read(asyncJoinProvider.notifier).formData['id'];
    final nick = await ref.read(asyncJoinProvider.notifier).formData['nick'];
    final route = ref.watch(routesProvider);
    final idChecked = ref.watch(idCheckProvider);
    final nickChecked = ref.watch(nickCheckProvider);

    if (id != null && nick != null && passwordController.text.length > 1) {
      JoinModel user =
          JoinModel(id: id, nick: nick, password: passwordController.text);
      final result = await ref.read(asyncJoinProvider.notifier).join(user);
      if (result) {
        // 가입됨
        _showToast('가입에 성공했어요!');
        setState(() {
          isAllValid = false;
        });
        route.goNamed(LoginScreen.routeName);
      }
    } else {
      if (id == null) {
        _showToast('아이디를 입력해 주세요');
        return;
      }
      if (nick == null) {
        _showToast('닉네임을 입력해 주세요');
        return;
      }
      if (passwordController.text.isEmpty) {
        _showToast('비밀번호를 입력해 주세요');
        return;
      }
      if (!idChecked) {
        _showToast('아이디 중복 확인을 해주세요');
        return;
      }
      if (!nickChecked) {
        _showToast('닉네임 중복 확인을 해주세요');
        return;
      }
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    final idChecked = ref.watch(idCheckProvider);
    final nickChecked = ref.watch(nickCheckProvider);

    // if (idFormKey.currentState?.validate() &&
    //     nickFormKey.currentState.validate() &&
    //     passwordFormKey.currentState!.validate() &&
    //     idChecked &&
    //     nickChecked) {
    //   setState(() {
    //     isAllValid = true;
    //   });
    // } else {
    //   setState(() {
    //     isAllValid = false;
    //   });
    // }
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
      body: SingleChildScrollView(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              debugPrint('gdgd');
              return;
            } else {
              debugPrint('dddd');
            }
            _showDialog();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: passwordFormKey,
              onChanged: () {
                if (idFormKey.currentState!.validate() &&
                    nickFormKey.currentState!.validate() &&
                    passwordFormKey.currentState!.validate() &&
                    idChecked &&
                    nickChecked) {
                  setState(() {
                    isAllValid = true;
                  });
                } else {
                  setState(() {
                    isAllValid = false;
                  });
                }
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SignIdFieldWidget(
                    formKey: idFormKey,
                  ),
                  SignNickFieldWidget(
                    formKey: nickFormKey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  RenderTextField2(
                                    focusNode: null,
                                    label: '비밀번호',
                                    validator: (value) {
                                      return ValidatorHooks.validatePassword(
                                          value);
                                    },
                                    onSaved: (value) {},
                                    onFieldSubmitted: (value) {},
                                    controller: passwordController,
                                    isAutoFocus: false,
                                    isPassword: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  RenderTextField2(
                                    focusNode: null,
                                    label: '비밀번호 확인',
                                    validator: (value) {
                                      return ValidatorHooks
                                          .validatePasswordCheck(
                                              passwordController.text, value);
                                    },
                                    onSaved: (value) {},
                                    onFieldSubmitted: (value) {},
                                    controller: passwordCheckController,
                                    isAutoFocus: false,
                                    isPassword: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isAllValid) {
                          _signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAllValid
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        '가입',
                        style: TextStyle(
                          color: isAllValid
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.secondary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    final route = ref.watch(routesProvider);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(
            '작성된 정보는 저장되지 않아요',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () {
                    route.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    '돌아가기',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displayLarge?.fontSize,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onPressed: () {
                    route.goNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

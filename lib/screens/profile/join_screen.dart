import 'package:crud/controllers/join_controller.dart';
import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/profile/login_screen.dart';
import 'package:crud/widgets/render_textField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  static const String routeName = 'join';
  static const String routePath = '/join';

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final formKey = GlobalKey<FormState>();
  bool formCheck = false;

  bool isIdValid = false, idCheck = false;
  String idMsg = '';
  String nickMsg = '';
  bool isNickValid = false, nickCheck = false;

  bool tappedId = false, tappedNick = false;

  Map<String, dynamic> formData = {
    "id": null,
    "nick": null,
    "password": null,
  };

  renderMsgField(String msg, bool state) {
    return Transform.translate(
      offset: const Offset(15, -39),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          color: state
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  renderButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          final isValided = formKey.currentState!.validate();
          if (isValided) {
            debugPrint('y');
          } else {
            debugPrint('no');
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: idCheck && nickCheck
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        child: Text(
          '가입',
          style: TextStyle(
            color: idCheck && nickCheck
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
          ),
        ),
      ),
    );
  }

  late final TextEditingController idController;
  late final TextEditingController nickController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordCheckController;

  void _changeIdMsg(bool result) {
    if (isIdValid && tappedId) {
      if (result) {
        setState(() {
          idMsg = '가입할 수 있어요';
          formData['id'] = idController.text;
        });
      } else {
        setState(() {
          idMsg = '이미 있는 아이디예요';
          formData['id'] = null;
        });
      }
    } else {
      setState(() {
        idMsg = '';
        idCheck = false;
      });
    }
  }

  void _changeNickMsg(bool result) {
    if (isNickValid && tappedNick) {
      if (result) {
        setState(() {
          nickMsg = '가입할 수 있어요';
          formData['nick'] = nickController.text;
        });
      } else {
        setState(() {
          nickMsg = '이미 있는 닉네임이에요';
          formData['nick'] = null;
        });
      }
    } else {
      setState(() {
        nickMsg = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nickController = TextEditingController();
    passwordController = TextEditingController();
    passwordCheckController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('aaa');
  }

  @override
  Widget build(BuildContext context) {
    final isIdCanJoin = ref.watch(idCheckProvider);
    final isNickCanJoin = ref.watch(nickCheckProvider);
    final isChecked = formData['id'] != null && formData['nick'] != null;

    _changeIdMsg(isIdCanJoin);
    _changeNickMsg(isNickCanJoin);
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
        child: Padding(
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
                  final idResult = ValidatorHooks.validateId(idController.text);
                  if (idResult == null) {
                    setState(() {
                      isIdValid = true;
                    });
                  } else {
                    setState(() {
                      isIdValid = false;
                    });
                  }
                  final nickResult =
                      ValidatorHooks.validateNick(nickController.text);
                  if (nickResult == null) {
                    setState(() {
                      isNickValid = true;
                    });
                  } else {
                    setState(() {
                      isNickValid = false;
                    });
                  }

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
                            // height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RenderTextField(
                                  label: '아이디',
                                  controller: idController,
                                  isAutoFocus: true,
                                  isPassword: false,
                                  validator: (value) {
                                    return ValidatorHooks.validateId(value);
                                  },
                                ),
                                renderMsgField(idMsg, isIdCanJoin),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isIdValid) {
                                    ref
                                        .read(idCheckProvider.notifier)
                                        .check(idController.text);
                                    setState(() {
                                      tappedId = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: isIdValid
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.surface,
                                ),
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.fontSize,
                                      color: isIdValid
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: double.infinity,
                            // height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RenderTextField(
                                  label: '닉네임',
                                  controller: nickController,
                                  isAutoFocus: true,
                                  isPassword: false,
                                  validator: (value) {
                                    return ValidatorHooks.validateNick(value);
                                  },
                                ),
                                renderMsgField(nickMsg, isNickCanJoin),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isNickValid) {
                                    ref
                                        .read(nickCheckProvider.notifier)
                                        .check(nickController.text);
                                    setState(() {
                                      tappedNick = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: isNickValid
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.surface,
                                ),
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.fontSize,
                                      color: isNickValid
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                          ],
                        )
                      ],
                    ),
                    RenderTextField(
                      label: '비밀번호',
                      controller: passwordController,
                      isAutoFocus: false,
                      isPassword: true,
                      validator: (value) {
                        return ValidatorHooks.validatePassword(value);
                      },
                    ),
                    RenderTextField(
                      label: '비밀번호 확인',
                      controller: passwordCheckController,
                      isAutoFocus: false,
                      isPassword: true,
                      validator: (value) {
                        return ValidatorHooks.validatePassword(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              renderButton(ref),
            ],
          ),
        ),
      ),
    );
  }
}

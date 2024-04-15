import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/models/join_model.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/screens/profile/widgets/sign_idField.dart';
import 'package:crud/screens/profile/widgets/sign_nickField.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool isAllValid = false;

  Future<void> _signUp() async {
    final id = await ref.read(asyncJoinProvider.notifier).formData['id'];
    final nick = await ref.read(asyncJoinProvider.notifier).formData['nick'];
    if (id != null && nick != null) {
      JoinModel user =
          JoinModel(id: id, nick: nick, password: passwordController.text);
      final result = await ref.read(asyncJoinProvider.notifier).join(user);
      if (!result) {
        final aa = ref.read(asyncJoinProvider.notifier).state;
        // print(aa);
      }
    } else {
      debugPrint('no');
    }
  }

  @override
  Widget build(BuildContext context) {
    final idChecked = ref.watch(idCheckProvider);
    final nickChecked = ref.watch(nickCheckProvider);

    if (idChecked && nickChecked) {
      setState(() {
        isAllValid = true;
      });
    } else {
      setState(() {
        isAllValid = false;
      });
    }
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
                                  label: '비밀번호 확인',
                                  validator: (value) {
                                    return ValidatorHooks.validatePasswordCheck(
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
                        fontSize:
                            Theme.of(context).textTheme.displayLarge?.fontSize,
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
    );
  }
}

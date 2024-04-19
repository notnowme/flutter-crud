import 'package:crud/hooks/toast.dart';
import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/models/login_model.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/providers/path_provider.dart';
import 'package:crud/routes.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/screens/profile/join_screen.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  static const String routeName = 'login';
  static const String routePath = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  FocusNode idFocus = FocusNode();
  FocusNode pwFocus = FocusNode();

  bool formCheck = false;
  renderButton() {
    final prevPage = ref.read(pathProvider);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (formCheck) {
            LoginModel user = LoginModel(
              id: idController.text,
              password: passwordController.text,
            );
            final result =
                await ref.read(asyncJoinProvider.notifier).login(user);
            if (result) {
              if (mounted) {
                if (prevPage.isEmpty) {
                  context.goNamed(Home.routeName);
                } else {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.goNamed(prevPage);
                }
              }
            } else {
              final data =
                  ref.read(asyncJoinProvider.notifier).getData()!['code'];
              switch (data) {
                case 401:
                  if (mounted) {
                    ToastMessage.showToast(context, 'error', '틀린 비밀번호예요');
                  }
                  passwordController.clear();
                  pwFocus.requestFocus();
                  break;
                case 404:
                  if (mounted) {
                    ToastMessage.showToast(context, 'error', '없는 아이디예요');
                  }
                  idFocus.requestFocus();
                  break;
              }
            }
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
    debugPrint('로그인 dispose');
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routesProvider);
    final prevPage = ref.watch(pathProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
        } else {
          context.pop();
          context.pushNamed(prevPage);
        }
      },
      child: Scaffold(
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
                            child: RenderTextField2(
                              focusNode: idFocus,
                              label: '아이디',
                              controller: idController,
                              isAutoFocus: true,
                              isPassword: false,
                              onSaved: (value) {},
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                return ValidatorHooks.validateId(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    RenderTextField2(
                      focusNode: pwFocus,
                      label: '비밀번호',
                      controller: passwordController,
                      isAutoFocus: false,
                      isPassword: true,
                      onFieldSubmitted: (value) {},
                      onSaved: (value) {},
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
              renderButton(),
              Row(
                children: [
                  Text(
                    '아직 가입하지 않았나요?',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize,
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
      ),
    );
  }
}

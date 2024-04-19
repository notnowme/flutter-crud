import 'package:crud/hooks/toast.dart';
import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/models/login_model.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showWithdrawDialog(BuildContext context, WidgetRef ref) {
  final passwordController = TextEditingController();
  final focusNode = FocusNode();
  final passwordFormKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Builder(
          builder: (_) {
            return SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '회원 탈퇴',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '탈퇴 시 모든 정보가 삭제되며\n복구되지 않습니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Form(
                      key: passwordFormKey,
                      child: RenderTextField2(
                        label: '',
                        validator: (value) {
                          return ValidatorHooks.validatePassword(value);
                        },
                        controller: passwordController,
                        isAutoFocus: true,
                        isPassword: true,
                        onSaved: (value) {},
                        onFieldSubmitted: (value) {},
                        focusNode: focusNode,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (passwordFormKey.currentState!.validate()) {
                            final userData = ref.watch(userProvider);
                            if (userData == null) {
                              return;
                            }
                            final result =
                                await withdraw(ref, passwordController.text);
                            if (!result) {
                              // 비밀번호 틀림
                              final code = ref
                                  .read(asyncJoinProvider.notifier)
                                  .getData()!['code'];
                              switch (code) {
                                case 401:
                                  if (context.mounted) {
                                    ToastMessage.showToast(
                                        context, 'error', '비밀번호가 틀렸어요');
                                    passwordController.clear();
                                    focusNode.requestFocus();
                                  }
                                  break;
                              }
                            } else {
                              // 비밀번호 맞음
                              final withdrawResult = await ref
                                  .read(asyncJoinProvider.notifier)
                                  .withdraw();
                              if (withdrawResult) {
                                // 탈퇴 성공
                                if (context.mounted) {
                                  ToastMessage.showToast(
                                      context, 'success', '탈퇴했어요');
                                  context.goNamed(Home.routeName);
                                }
                              }
                            }
                          }
                        },
                        child: Text(
                          '탈퇴',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Future<bool> withdraw(WidgetRef ref, String password) async {
  final userData = ref.watch(userProvider);
  LoginModel user = LoginModel(id: userData!['id'], password: password);
  final result = await ref.read(asyncJoinProvider.notifier).checkPassword(user);
  return result;
}

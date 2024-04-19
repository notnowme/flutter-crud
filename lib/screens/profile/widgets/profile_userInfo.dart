import 'package:crud/hooks/toast.dart';
import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/providers/user_provider.dart';
import 'package:crud/screens/home/home.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class UserInfoWidget extends ConsumerStatefulWidget {
  const UserInfoWidget({super.key});

  @override
  ConsumerState<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget> {
  @override
  void initState() {
    ref.read(userProvider.notifier).init();
    super.initState();
  }

  final nickController = TextEditingController();
  final focusNode = FocusNode();
  final nickFormKey = GlobalKey<FormState>();

  Future<void> _changeNick() async {
    if (nickFormKey.currentState!.validate()) {
      final result = await ref
          .read(asyncJoinProvider.notifier)
          .changeNick(nickController.text);
      if (result) {
        // 변경 성공
        if (mounted) {
          ToastMessage.showToast(context, 'success', '변경했어요!');
          ref.read(userProvider.notifier).init();
          nickController.clear();
          context.pop();
          setState(() {});
        }
      } else {
        final data = ref.read(asyncJoinProvider.notifier).getData()!['code'];
        switch (data) {
          case 401:
            if (mounted) {
              ToastMessage.showToast(context, 'error', '다시 로그인해 주세요');
              context.goNamed(Home.routeName);
            }
            break;
          case 409:
            if (mounted) {
              ToastMessage.showToast(context, 'error', '이미 있는 닉네임이에요');
            }
            nickController.clear();
            focusNode.requestFocus();
            break;
        }
      }
    } else {
      debugPrint('프로필 바텀시트 no');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData == null ? ' ' : userData['nick'],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize),
                    ),
                    Text(
                      userData == null ? ' ' : userData['id'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              onPressed: () {
                _showBottomSheet();
              },
              icon: const Icon(Icons.create),
              color: Theme.of(context).colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(27),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            nickController.clear();
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '닉네임 변경',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Form(
                              key: nickFormKey,
                              child: RenderTextField2(
                                label: '',
                                validator: (value) {
                                  return ValidatorHooks.validateNick(value);
                                },
                                controller: nickController,
                                isAutoFocus: true,
                                isPassword: false,
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
                                  nickController.clear();
                                  context.pop();
                                },
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 60,
                              ),
                              TextButton(
                                onPressed: () {
                                  _changeNick();
                                },
                                child: Text(
                                  '변경',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

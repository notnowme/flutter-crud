import 'package:crud/providers/join_provider.dart';
import 'package:crud/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NickFieldWidget extends ConsumerStatefulWidget {
  const NickFieldWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  ConsumerState<NickFieldWidget> createState() => _NickFieldWidgetState();
}

class _NickFieldWidgetState extends ConsumerState<NickFieldWidget> {
  bool nickCheck = false, isLengthFour = false;

  final _nickFormKey = GlobalKey<FormState>();

  String handleNickReg(String nick) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9가-힣!@#$%^*+=\- ]+$');
    if (!regex.hasMatch(nick)) {
      return '입력할 수 없는 문자가 있어요';
    }
    if (nick.length < 4) {
      return '4글자 이상 입력해야해요';
    }
    if (nick.length > 13) {
      return '13글자까지만 가능해요';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isCanJoin = ref.watch(nickCheckProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Form(
                onChanged: () {
                  if (widget.controller.text.length > 4) {
                    setState(() {
                      isLengthFour = true;
                    });
                  } else {
                    setState(() {
                      isLengthFour = false;
                      nickCheck = false;
                    });
                  }
                },
                key: _nickFormKey,
                child: InputFieldWidget(
                  cat: '닉네임',
                  controller: widget.controller,
                  isAutoFocus: false,
                  isPassword: false,
                  isError: nickCheck,
                  validFunction: handleNickReg,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 49,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isLengthFour) return;
                      if (_nickFormKey.currentState!.validate()) {
                        setState(() {
                          nickCheck = true;
                        });
                      } else {
                        setState(() {
                          nickCheck = false;
                        });
                      }
                      if (!nickCheck) return;
                      ref
                          .read(nickCheckProvider.notifier)
                          .check(widget.controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: isLengthFour
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.surface,
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.displayLarge?.fontSize,
                        color: isLengthFour
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(10, -20),
          child: Text(
            nickCheck
                ? isCanJoin
                    ? '가입할 수 있어요'
                    : '이미 있는 닉네임이에요'
                : '',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              color: isCanJoin
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

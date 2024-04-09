import 'package:crud/providers/join_provider.dart';
import 'package:crud/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PwFieldWidget extends ConsumerStatefulWidget {
  const PwFieldWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  ConsumerState<PwFieldWidget> createState() => _PwFieldWidgetState();
}

class _PwFieldWidgetState extends ConsumerState<PwFieldWidget> {
  bool idCheck = false, isLengthFour = false;

  final _idFormKey = GlobalKey<FormState>();

  String handlePwReg(String pw) {
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
    final isCanJoin = ref.watch(idCheckProvider);
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
                      idCheck = false;
                    });
                  }
                },
                key: _idFormKey,
                child: InputFieldWidget(
                  cat: '아이디',
                  controller: widget.controller,
                  isAutoFocus: false,
                  isPassword: false,
                  isError: idCheck,
                  validFunction: handlePwReg,
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
                      if (_idFormKey.currentState!.validate()) {
                        setState(() {
                          idCheck = true;
                        });
                      } else {
                        setState(() {
                          idCheck = false;
                        });
                      }
                      if (!idCheck) return;
                      ref
                          .read(idCheckProvider.notifier)
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
            idCheck
                ? isCanJoin
                    ? '가입할 수 있어요'
                    : '이미 있는 아이디예요'
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

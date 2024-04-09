import 'package:crud/providers/join_provider.dart';
import 'package:crud/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdFieldWidget extends ConsumerStatefulWidget {
  const IdFieldWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  ConsumerState<IdFieldWidget> createState() => _IdFieldWidgetState();
}

class _IdFieldWidgetState extends ConsumerState<IdFieldWidget> {
  bool idCheck = false, isLengthFour = false;

  final _idFormKey = GlobalKey<FormState>();

  String handleIdReg(String id) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_\.]+$');
    if (!regex.hasMatch(id)) {
      return '입력할 수 없는 문자가 있어요';
    }
    if (id.length < 4) {
      return '4글자 이상 입력해야해요';
    }
    if (id.length > 20) {
      return '20글자까지만 입력할 수 있어요';
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
                  validFunction: handleIdReg,
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

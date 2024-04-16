import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignNickFieldWidget extends ConsumerStatefulWidget {
  const SignNickFieldWidget({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<SignNickFieldWidget> createState() =>
      _SignNickFieldWidgetState();
}

class _SignNickFieldWidgetState extends ConsumerState<SignNickFieldWidget> {
  final TextEditingController nickController = TextEditingController();

  String nickMsg = '';
  bool isValid = false;
  bool nickChecked = false;

  Future<void> _checkNick(String nick) async {
    if (widget.formKey.currentState!.validate()) {
      final state = await ref.read(asyncJoinProvider.notifier).checkNick(nick);
      if (state) {
        ref.read(asyncJoinProvider.notifier).setNick(nick);
        ref.read(nickCheckProvider.notifier).state = true;
        setState(() {
          nickMsg = '가입할 수 있어요';
        });
      } else {
        ref.read(nickCheckProvider.notifier).state = false;
        ref.read(asyncJoinProvider.notifier).setNick(null);
        setState(() {
          nickMsg = '이미 있는 닉네임이에요';
        });
      }
    } else {
      ref.read(nickCheckProvider.notifier).state = false;
      ref.read(asyncJoinProvider.notifier).setNick(null);
      setState(() {
        nickMsg = '';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickChecked = ref.watch(nickCheckProvider);
    return Column(
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
                    Form(
                      key: widget.formKey,
                      onChanged: () {
                        if (!widget.formKey.currentState!.validate()) {
                          setState(() {
                            nickMsg = '';
                            ref.read(nickCheckProvider.notifier).state = false;
                            isValid = false;
                          });
                        } else {
                          setState(() {
                            isValid = true;
                          });
                        }
                      },
                      child: RenderTextField2(
                        focusNode: null,
                        label: '닉네임',
                        validator: (value) {
                          return ValidatorHooks.validateNick(value);
                        },
                        onSaved: (value) async {},
                        onFieldSubmitted: (value) {},
                        controller: nickController,
                        isAutoFocus: false,
                        isPassword: false,
                      ),
                    )
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
                      _checkNick(nickController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: isValid
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.surface,
                    ),
                    child: Text('확인',
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.fontSize,
                          color: isValid
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.secondary,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(15, -39),
          child: Text(
            nickMsg,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              color: nickChecked
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

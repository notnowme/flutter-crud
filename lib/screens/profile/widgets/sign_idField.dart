import 'package:crud/hooks/vali_hooks.dart';
import 'package:crud/providers/join_provider.dart';
import 'package:crud/widgets/render_textField2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignIdFieldWidget extends ConsumerStatefulWidget {
  const SignIdFieldWidget({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  @override
  ConsumerState<SignIdFieldWidget> createState() => _SignIdFieldWidgetState();
}

class _SignIdFieldWidgetState extends ConsumerState<SignIdFieldWidget> {
  final TextEditingController idController = TextEditingController();

  String idMsg = '';
  bool isValid = false;
  bool idChecked = false;

  Future<void> _checkId(String id) async {
    if (widget.formKey.currentState!.validate()) {
      final state = await ref.read(asyncJoinProvider.notifier).checkId(id);
      if (state) {
        ref.read(asyncJoinProvider.notifier).setId(id);
        ref.read(idCheckProvider.notifier).state = true;
        setState(() {
          idMsg = '가입할 수 있어요';
        });
      } else {
        ref.read(asyncJoinProvider.notifier).setId(null);
        ref.read(idCheckProvider.notifier).state = false;
        setState(() {
          idMsg = '이미 있는 아이디예요';
        });
      }
    } else {
      ref.read(asyncJoinProvider.notifier).setId(null);
      ref.read(idCheckProvider.notifier).state = false;
      setState(() {
        idMsg = '';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final idChecked = ref.watch(idCheckProvider);
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
                            idMsg = '';
                            ref.read(idCheckProvider.notifier).state = false;
                            isValid = false;
                          });
                        } else {
                          setState(() {
                            isValid = true;
                          });
                        }
                      },
                      child: RenderTextField2(
                        label: '아이디',
                        validator: (value) {
                          return ValidatorHooks.validateId(value);
                        },
                        onSaved: (value) async {},
                        onFieldSubmitted: (value) {},
                        controller: idController,
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
                      _checkId(idController.text);
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
            idMsg,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              color: idChecked
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}

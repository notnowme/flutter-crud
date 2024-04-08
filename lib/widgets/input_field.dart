import 'package:flutter/material.dart';

class InputFieldWidget extends StatefulWidget {
  final String cat;
  final TextEditingController controller;
  final bool isAutoFocus;
  final bool isPassword;
  final bool isError;
  const InputFieldWidget({
    super.key,
    required this.cat,
    required this.controller,
    required this.isAutoFocus,
    required this.isPassword,
    required this.isError,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  late FocusNode _focusNode;
  late bool hiddenPassword;
  String msg = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    hiddenPassword = widget.isPassword;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

// ^[a-zA-Z0-9_.@!#$%^&*()-+=<>?/{}\[\],:;'"\\]+$

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.cat,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 50,
          child: TextFormField(
            focusNode: _focusNode,
            autofocus: widget.isAutoFocus,
            controller: widget.controller,
            obscureText: hiddenPassword,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                errorStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.isError
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
                suffix: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            hiddenPassword = !hiddenPassword;
                          });
                        },
                        icon: hiddenPassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        color: Colors.black,
                      )
                    : null),
          ),
        ),
      ],
    );
  }
}

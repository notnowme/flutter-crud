import 'package:flutter/material.dart';

class RenderTextField extends StatefulWidget {
  const RenderTextField({
    super.key,
    required this.label,
    required this.validator,
    required this.controller,
    required this.isAutoFocus,
    required this.isPassword,
  });

  final String label;
  final bool isAutoFocus;
  final bool isPassword;
  final FormFieldValidator validator;
  final TextEditingController controller;

  @override
  State<RenderTextField> createState() => _RenderTextFieldState();
}

class _RenderTextFieldState extends State<RenderTextField> {
  late bool hiddenPassword;

  void _clearTextField() {
    widget.controller.clear();
  }

  @override
  void initState() {
    super.initState();
    hiddenPassword = widget.isPassword;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('aaa');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 80,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            autofocus: widget.isAutoFocus,
            autovalidateMode: AutovalidateMode.always,
            obscureText: hiddenPassword,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
            ),
            decoration: InputDecoration(
              helperText: ' ',
              helperStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              isDense: true,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                color: Theme.of(context).colorScheme.error,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          hiddenPassword = !hiddenPassword;
                        });
                      },
                      icon: Icon(hiddenPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

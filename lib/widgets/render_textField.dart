import 'package:flutter/material.dart';

class RenderTextField extends StatelessWidget {
  const RenderTextField({
    super.key,
    required this.label,
    required this.onSaved,
    required this.validator,
  });

  final String label;
  final FormFieldSetter onSaved;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.always,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}
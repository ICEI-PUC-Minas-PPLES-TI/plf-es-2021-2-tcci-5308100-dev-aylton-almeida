import 'package:flutter/material.dart';

class OutlinedTextField extends TextFormField {
  OutlinedTextField({
    Key? key,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    String? hintText,
    int? maxLength,
  }) : super(
          key: key,
          controller: controller,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            counterText: '',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: validator,
          onChanged: onChanged,
        );
}

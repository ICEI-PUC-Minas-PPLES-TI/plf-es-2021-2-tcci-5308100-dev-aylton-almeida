import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlinedTextField extends TextFormField {
  OutlinedTextField({
    Key? key,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    String? hintText,
    String? errorText,
    int? maxLength,
    int? minLines = 1,
    int? maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    double borderRadius = 100,
  }) : super(
          key: key,
          controller: controller,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
          ),
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
        );
}

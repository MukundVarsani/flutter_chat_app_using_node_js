import 'package:flutter/material.dart';


class InputFormField extends StatefulWidget {
   const InputFormField({super.key, 
    required this.controller,
    this.hintText,
    required this.validator,
    this.icon = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?) validator;
  final bool icon;

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
     bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: widget.controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            suffixIcon: widget.icon
                ? IconButton(
                    color: Colors.white.withOpacity(0.7),
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    icon: isPassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))
                : const SizedBox(),
            contentPadding: const EdgeInsets.all(15),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.white),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(width: 1, color: Colors.white.withOpacity(0.7)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(width: 1, color: Colors.white.withOpacity(0.7)),
            ),
            errorStyle: TextStyle(color: Colors.red.shade200),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5))),
        validator: widget.validator);
  }
}

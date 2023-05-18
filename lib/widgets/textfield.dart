import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  const Textfield(
      {super.key,
      required this.label,
      required this.controller,
      required this.hint,
      required this.validator,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 66, 9, 147), width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onTap: onTap,
        validator: validator);
  }
}

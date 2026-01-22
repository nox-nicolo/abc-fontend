import 'package:flutter/material.dart';

class CustomeField extends StatelessWidget {
  const CustomeField({
    super.key,
    required this.hintText,
    required this.leadingIcon,
    required this.keyboardType,
    required this.action,
    this.obscure = false,
    required this.controller,
  });

  final String hintText;
  final IconData leadingIcon;
  final TextInputType keyboardType;
  final TextInputAction action;
  final bool obscure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, 
      keyboardType: keyboardType,
      textInputAction: action,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(leadingIcon),
        hintText: hintText,
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return '$hintText is missing';
        } else {
          // Trim the input value before returning null
          controller.text = val.trim(); 
          return null; 
        }
      },
    );
  }
}
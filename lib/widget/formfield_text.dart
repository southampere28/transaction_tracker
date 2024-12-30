import 'package:flutter/material.dart';
import 'package:transaction_tracker/theme.dart';

class FormfieldText extends StatelessWidget {
  const FormfieldText({
    super.key,
    required this.controller,
    required this.icon,
    required this.keyType,
    required this.labelField,
    required this.hintTxt,
  });

  final TextEditingController controller;
  final Widget? icon;
  final TextInputType keyType;
  final String labelField;
  final String hintTxt;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // use the controller to fill the text field
      keyboardType: keyType,
      decoration: InputDecoration(
        hintText: hintTxt,
        hintStyle: subtitleTextStyle,
        labelText: labelField,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: blackTextStyle
            .copyWith(fontSize: 16, fontWeight: bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryColor,
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryColor,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
    );
  }
}

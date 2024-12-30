import 'package:flutter/material.dart';
import 'package:transaction_tracker/theme.dart';

class DropdownWidget extends StatefulWidget {
  DropdownWidget({
    super.key,
    required this.labeltxt,
    required this.hinttxt,
    required this.value,
    required this.dropdownItem,
    required this.onChanged,
  });

  final String labeltxt;
  final String hinttxt;
  String? value;
  final Function(String?)? onChanged;
  final List<String> dropdownItem;

  // String? _valueGender;
  // final List<String> _dropdownItemsGender = ["Laki

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: widget.labeltxt,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: blackTextStyle
            .copyWith(fontSize: 16, fontWeight: bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
      value: widget.value,
      style: blackTextStyle.copyWith(
        fontSize: 16,
        fontWeight: medium,
      ),
      items: widget.dropdownItem.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
      hint: Text(
        widget.hinttxt,
        style: subtitleTextStyle,
      ),
      onChanged: widget.onChanged,
    );
  }
}

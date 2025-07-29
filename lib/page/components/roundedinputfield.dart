import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perisai_nusantara_app/page/components/textfieldcontainer.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final ValueChanged<String> onChanged;
  final double? width;
  final TextInputType? inputType;
  const RoundedInputField(
      {Key? key,
      required this.hintText,
      this.icon,
      required this.onChanged,
      this.width,
      this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: width,
      child: TextField(
        keyboardType: inputType,
        onChanged: onChanged,
        cursorColor: Colors.red.shade300,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.red.shade700,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

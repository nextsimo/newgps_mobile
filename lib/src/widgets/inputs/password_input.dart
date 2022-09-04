import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class PasswordInput extends StatefulWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final void Function() onEditeComplete;

  const PasswordInput(
      {Key? key,
      required this.icon,
      this.hint = '',
      required this.controller,
      required this.validator,
      required this.onEditeComplete})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: widget.onEditeComplete,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: IconButton(
          icon:  Icon(_obscureText  ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(()=> _obscureText = !_obscureText),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 10),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConsts.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(widget.icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

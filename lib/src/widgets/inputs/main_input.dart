import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class MainInput extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String hint;
  final double? width;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onchanged;
  final void Function()? onEditeComplete;
  final double? heigt;
  final bool autofocus;
  final TextInputType? textInputType;
  final String? labelText;

  const MainInput({
    Key? key,
    this.icon,
    this.hint = '',
    this.controller,
    this.validator,
    this.onEditeComplete,
    this.onchanged,
    this.color,
    this.width,
    this.heigt,
    this.autofocus = false, this.textInputType, this.labelText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigt,
      child: TextFormField(
        keyboardType: textInputType,
        autofocus: autofocus,
        onEditingComplete: onEditeComplete,
        controller: controller,
        validator: validator,
        onChanged: onchanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: color ?? Colors.grey[300],
          hintText: hint,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIconConstraints: const BoxConstraints(
          ),
          prefixIcon: icon == null
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppConsts.mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

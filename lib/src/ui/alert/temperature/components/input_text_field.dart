import 'package:flutter/cupertino.dart';



class MyInputTextField extends StatelessWidget {
  final String? placeholder;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const MyInputTextField({Key? key,  this.placeholder, this.icon, this.keyboardType, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: keyboardType,
      placeholder:placeholder,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      prefix:  Padding(
        padding:  const EdgeInsets.only(left: 8),
        child:  Icon(icon, color: CupertinoColors.systemGrey),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.lightBackgroundGray,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}



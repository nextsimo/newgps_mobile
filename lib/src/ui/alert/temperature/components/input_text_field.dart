import 'package:flutter/cupertino.dart';

import '../../../../utils/styles.dart';



class MyInputTextField extends StatelessWidget {
  final String? placeholder;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const MyInputTextField({super.key,  this.placeholder, this.icon, this.keyboardType, this.controller});

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
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
      ),
    );
  }
}



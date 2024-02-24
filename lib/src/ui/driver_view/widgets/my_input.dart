import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class NewgInput extends StatelessWidget {
  final String? placeholder;
  final Widget? prefix;
  final TextInputType? keyboardType;

  const NewgInput({super.key, this.placeholder, this.prefix, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoTextField(
        prefix: prefix,
        keyboardType: keyboardType,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        placeholder: placeholder,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          border: Border.all(
            color: const Color(0xfffbe4dd),
            width: 1,
          ),
          color: const Color(0xfffff9f6),
        ),
      ),
    );
  }
}

class InputPrefix {
  static Widget phonePrefix() {
    return mainPrefix(
      child: const Text(
        "+ 212",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppConsts.mainColor,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  static Widget idPrefix() {
    return mainPrefix(
      child: const Icon(
        Icons.device_hub_outlined,
        color: AppConsts.mainColor,
      ),
    );
  }

  static Widget mainPrefix({required Widget child}) {
    return Container(
      width: 59,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConsts.mainradius),
          topRight: const Radius.circular(0),
          bottomLeft: Radius.circular(AppConsts.mainradius),
          bottomRight: const Radius.circular(0),
        ),
        color: const Color.fromARGB(83, 136, 190, 61),
      ),
      child: Center(child: child),
    );
  }
}

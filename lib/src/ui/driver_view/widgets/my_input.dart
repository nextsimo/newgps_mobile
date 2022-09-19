import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class NewgInput extends StatelessWidget {
  final String? placeholder;
  final Widget? prefix;
  final TextInputType? keyboardType;

  const NewgInput({Key? key, this.placeholder, this.prefix, this.keyboardType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoTextField(
        prefix: prefix,
        keyboardType: keyboardType,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        placeholder: placeholder,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(0),
        ),
        color: Color.fromARGB(83, 136, 190, 61),
      ),
      child: Center(child: child),
    );
  }
}
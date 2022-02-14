import 'package:flutter/material.dart';

class RotateIconMap extends StatelessWidget {
  final void Function() normalview;
  const RotateIconMap({Key? key, required this.normalview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: normalview,
      child: const SizedBox(
        width: 40,
        height: double.infinity,
        child:  Icon(
          Icons.navigation_outlined,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}

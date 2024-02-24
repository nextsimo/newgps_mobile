import 'package:flutter/material.dart';

class RotateIconMap extends StatelessWidget {
  final void Function() normalview;
  const RotateIconMap({super.key, required this.normalview});

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

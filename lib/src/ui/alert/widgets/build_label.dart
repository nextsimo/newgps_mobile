import 'package:flutter/material.dart';

class BuildLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const BuildLabel({Key? key, required this.label, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
          size: 32,
        ),
        const SizedBox(width: 10),
        Text(
          'Alerte $label:',
        ),
      ],
    );
  }
}

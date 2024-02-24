import 'package:flutter/material.dart';

class BuildLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const BuildLabel({super.key, required this.label, required this.icon});

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

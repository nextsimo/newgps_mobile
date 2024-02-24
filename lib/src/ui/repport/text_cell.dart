import 'package:flutter/material.dart';

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color? color;
  final int flex;

  const BuildTextCell(this.content, {super.key, this.color, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 10,
        color: color,
        child: Center(
          child: SelectableText(
            content,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

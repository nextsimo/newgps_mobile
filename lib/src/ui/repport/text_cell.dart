import 'package:flutter/material.dart';

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color? color;
  final int flex;

  const BuildTextCell(this.content, {Key? key, this.color, this.flex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 10,
        color: color,
        child: Center(
          child: Text(
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

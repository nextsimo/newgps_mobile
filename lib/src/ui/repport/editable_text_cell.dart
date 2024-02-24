import 'package:flutter/material.dart';

class EditableCell extends StatelessWidget {
  final String content;
  final void Function(String val) onchanged;
  EditableCell({super.key, required this.content, required this.onchanged});

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _controller.text = content;
    return TextField(
      controller: _controller,
      onChanged: onchanged,
      onTap: () => {
        _controller.selection =
            TextSelection(baseOffset: 0, extentOffset: _controller.text.length)
      },
      maxLines: 1,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
    );
  }
}

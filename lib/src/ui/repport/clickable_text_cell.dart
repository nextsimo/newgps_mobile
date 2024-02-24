import 'package:flutter/material.dart';

class BuildClickableTextCell extends StatelessWidget {
  final void Function(int? index)? ontap;
  final String content;
  final Color color;
  final int flex;
  final bool isSlected;
  final bool isUp;
  final int? index;
  const BuildClickableTextCell(this.content,
      {super.key,
      this.color = Colors.black,
      this.flex = 1,
      this.ontap,
      this.isSlected = false,
      this.isUp = true,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => ontap!(index),
        child: Container(
          color: isSlected ? Colors.white : Colors.transparent,
          height: 20,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 7,
                  ),
                ),
              ),
              if (ontap != null)
                Positioned(
                  right: 0,
                  bottom: -4,
                  child: Icon(
                      isUp && isSlected
                          ? Icons.arrow_drop_down_outlined
                          : Icons.arrow_drop_up_outlined,
                      size: 12),
                )
            ],
          ),
        ),
      ),
    );
  }
}

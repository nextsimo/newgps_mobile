import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class BuildDivider extends StatelessWidget {
  final double height;
  const BuildDivider({
    Key? key,
    this.height = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: AppConsts.mainColor,
      height: height,
    );
  }
}

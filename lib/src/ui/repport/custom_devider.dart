import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class BuildDivider extends StatelessWidget {
  final double height;
  const BuildDivider({
    super.key,
    this.height = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: AppConsts.mainColor,
      height: height,
    );
  }
}

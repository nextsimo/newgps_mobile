import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class MyMainButton extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final Color textColor;
  final GestureTapCallback? onTap;
  final Color borderColor;
  final double? width;
  const MyMainButton(
      {Key? key,
      this.onTap,
      this.label = 'Enregistrer',
      this.width,
      this.backgroundColor = AppConsts.mainColor,
      this.textColor = Colors.white,  this.borderColor = AppConsts.mainColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            border: Border.all(color: borderColor, width: 1.3),
            color: backgroundColor,
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

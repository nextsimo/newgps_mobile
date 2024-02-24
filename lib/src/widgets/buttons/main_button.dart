import 'dart:developer';
import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class MainButton extends StatefulWidget {
  const MainButton(
      {super.key,
      this.label = '',
      required this.onPressed,
      this.backgroundColor = AppConsts.mainColor,
      this.width,
      this.height = 48,
      this.borderColor,
      this.textColor = Colors.white,
      this.icon,
      this.fontSize = 12.5});

  final Color backgroundColor;
  final Color? borderColor;
  final double fontSize;
  final double height;
  final IconData? icon;
  final String label;
  final dynamic Function() onPressed;
  final Color textColor;
  final double? width;

  @override
  // ignore: library_private_types_in_public_api
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool _loding = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConsts.mainradius),
                  side: BorderSide(
                      color: widget.borderColor ?? widget.backgroundColor))),
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => widget.backgroundColor),
        ),
        onPressed: () async {
          try {
            setState(() => _loding = true);
            await widget.onPressed();
            setState(() => _loding = false);
          } catch (e) {
            log('-->${widget.label}', error: '$e');
            setState(() => _loding = false);
          }
        },
        child: _loding
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Icon(widget.icon, color: Colors.white, size: 17),
                    ),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

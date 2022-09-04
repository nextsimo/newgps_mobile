import 'package:flutter/material.dart';
import '../logic/temperature_provider.dart';
import 'package:provider/provider.dart';

class ValidationMessage extends StatelessWidget {
  const ValidationMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _message = context.select<TemperatureBleProvider, String>(
        ((value) => value.validationMessage));

    return Text(
      _message,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.red,
      ),
    );
  }
}

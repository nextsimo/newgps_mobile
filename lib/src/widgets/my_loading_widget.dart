import 'package:flutter/material.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

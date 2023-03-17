import 'package:flutter/material.dart';

import '../src/utils/styles.dart';

class MyLoadingBar extends StatelessWidget {
  const MyLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      child: LinearProgressIndicator(
        color: AppConsts.mainColor,
      ),
    );
  }
}

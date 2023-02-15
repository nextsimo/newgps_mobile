import 'package:flutter/material.dart';

import '../navigation/top_app_bar.dart';

class ClassicMoreInfo extends StatelessWidget {
  const ClassicMoreInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        actions: [],
      ),
      body: Column(),
    );
  }
}

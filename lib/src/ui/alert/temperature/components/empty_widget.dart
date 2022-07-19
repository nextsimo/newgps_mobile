import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class MyEmptyWidget extends StatelessWidget {
  const MyEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: EmptyWidget(
          image: null,
          packageImage: PackageImage.Image_3,
          title: 'Aucune configuration',
          subTitle: 'Veuillez ajouter une configuration',
          titleTextStyle: const TextStyle(
            fontSize: 22,
            color: Color(0xff9da9c7),
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xffabb8d6),
          ),
        ),
      ),
    );
  }
}

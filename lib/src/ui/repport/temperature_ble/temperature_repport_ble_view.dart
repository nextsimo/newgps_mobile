import 'package:flutter/material.dart';
import '../../../utils/styles.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';

class TemperatureRepportBleView extends StatelessWidget {
  const TemperatureRepportBleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        right: false,
        bottom: false,
        top: false,
        child: Column(
          children: const [
            _BuildHead(),
          ],
        ),
      ),
    );
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          BuildClickableTextCell(
            "Date",
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 1,
            flex: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Heure',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 1,
            flex: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'T1 (°C)',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 3,
            flex: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'T2 (°C)',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 4,
            flex: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'T3 (°C)',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 4,
            flex: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'T4 (°C)',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 4,
            flex: 1,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

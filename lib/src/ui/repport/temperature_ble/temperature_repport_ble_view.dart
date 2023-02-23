import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../../widgets/empty_data.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../rapport_provider.dart';
import 'temp_ble_repport_model.dart';
import 'temperature_repport_provider.dart';

class TemperatureRepportBleView extends StatelessWidget {
  const TemperatureRepportBleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<TemperatureRepportProvider>(context, listen: false);

    provider.init(context.read<RepportProvider>());

    return Material(
      child: SafeArea(
        right: false,
        bottom: false,
        top: false,
        child: Consumer<TemperatureRepportProvider>(
          builder: (_, ___, __) {
            return Column(
              children: [
                const _BuildHead(),
                Consumer<TemperatureRepportProvider>(
                    builder: (context, pro, __) {
                  if (pro.repports.isEmpty) {
                    return  SizedBox(
                      height: 180.h,
                      child: const Center(child: EmptyData()),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: pro.repports.length,
                      itemBuilder: (_, int index) {
                        return _RepportRow(
                          repport: pro.repports.elementAt(index),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  final TemBleRepportModel repport;
  const _RepportRow({
    Key? key,
    required this.repport,
  }) : super(key: key);

  // draw triangle in the screen to show the direction of the wind

  @override
  Widget build(BuildContext context) {
    // read provider
    TemperatureRepportProvider provider =
        context.read<TemperatureRepportProvider>();
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(),
          _BuildTextCell(formatSimpleDate(repport.timestamp)),
          const BuildDivider(),
          _BuildTextCell(formatToSimpleTime(repport.timestamp)),
          const BuildDivider(),
          _BuildTextCell(provider.checkTemperature(repport.temperature1)),
          const BuildDivider(),
        ],
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
            'Température (°C)',
            ontap: (_) {},
            isSlected: false,
            isUp: true,
            index: 3,
            flex: 1,
          ),
          const BuildDivider(),
         
        ],
      ),
    );
  }
}

class _BuildTextCell extends StatelessWidget {
  final String content;

  const _BuildTextCell(this.content, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

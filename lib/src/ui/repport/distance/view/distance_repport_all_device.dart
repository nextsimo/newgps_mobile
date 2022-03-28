import 'package:flutter/material.dart';
import 'package:newgps/src/ui/repport/distance/models/repport_distance_model.dart';
import 'package:newgps/src/ui/repport/distance/provider/distance_provider.dart';
import 'package:provider/provider.dart';
import '../../../../utils/styles.dart';
import '../../clickable_text_cell.dart';
import '../../custom_devider.dart';
import '../../rapport_provider.dart';
import '../../text_cell.dart';

class DistanceRepportAllDeviceView extends StatefulWidget {
  const DistanceRepportAllDeviceView({Key? key}) : super(key: key);

  @override
  State<DistanceRepportAllDeviceView> createState() =>
      _DistanceRepportAllDeviceViewState();
}

class _DistanceRepportAllDeviceViewState
    extends State<DistanceRepportAllDeviceView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context, listen: false);

    provider.initContrtoller(_scrollController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<RepportProvider>(context);
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context, listen: false);
    provider.fetchForAllDevices(p: 1);

    return Material(
      child: SafeArea(
        right: false,
        bottom: false,
        top: false,
        child: Column(
          children: [
            const _BuildHead(),
            Expanded(
              child: Consumer<DistanceRepportProvider>(
                  builder: (context, provider, _) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppConsts.mainColor.withOpacity(0.8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Total distance parcorue:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          const Expanded(child: SizedBox()),
                          Expanded(
                            child: Center(
                              child: Text(
                                "${provider.distanceSum}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        itemCount: provider.repport.repports.length,
                        itemBuilder: (_, int index) {
                          return _RepportRow(
                            model: provider.repport.repports.elementAt(index),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
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
    DistanceRepportProvider provider =
        Provider.of<DistanceRepportProvider>(context);
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
            'Matricule',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(0),
            isUp: provider.up,
            index: 0,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km départ',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(1),
            isUp: provider.up,
            index: 1,
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Km fin',
            ontap: provider.orderByClick,
            isUp: provider.up,
            index: 2,
            isSlected: provider.isSelected(2),
          ),
          const BuildDivider(),
          BuildClickableTextCell(
            'Distance parcorue(Km)',
            ontap: provider.orderByClick,
            isSlected: provider.isSelected(3),
            isUp: provider.up,
            index: 3,
          ),
          const BuildDivider(),
        ],
      ),
    );
  }
}

class _RepportRow extends StatelessWidget {
  final Repport model;
  const _RepportRow({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          BuildTextCell(model.description),
          const BuildDivider(),
          BuildTextCell('${model.startKm}'),
          const BuildDivider(),
          BuildTextCell('${model.endKm}'),
          const BuildDivider(),
          BuildTextCell('${model.distance}'),
          const BuildDivider(),
        ],
      ),
    );
  }
}

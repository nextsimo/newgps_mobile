import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:provider/provider.dart';

class DateHourWidget extends StatelessWidget {
  final double width;
  final void Function()? ontap;
  const DateHourWidget({Key? key, this.width = 400.0, this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoricProvider historicProvider = Provider.of<HistoricProvider>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: ontap,
      child: SafeArea(
        bottom: false,
        top: false,
        right: false,
        child: Container(
          height: orientation == Orientation.portrait ? 35 : 30,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppConsts.mainColor, width: 1),
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    historicProvider.updateDate(context);
                  },
                  child: Center(
                    child: Text(
                      formatDeviceDate(historicProvider.dateFrom, false),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: 1,
                color: AppConsts.mainColor,
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () => historicProvider.updateTimeRange(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            formatToSimpleTime(historicProvider.dateFrom), 
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const Text(
                        'à',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            formatToSimpleTime(historicProvider.dateTo),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

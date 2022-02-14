/* import 'package:flutter/material.dart';
import 'package:newgps/src/utils/functions.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

class DateHourGlobal extends StatelessWidget {
  final double width;
  const DateHourGlobal({Key? key, this.width = 400.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);
    context.select<RepportProvider, bool>((_) => _.notifyDate);
    return Container(
      height: 34,
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
                repportProvider.updateDate(context);
              },
              child: Center(
                child: Text(formatSimpleDate(repportProvider.dateFrom, false)),
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
              onTap: () => repportProvider.updateTimeRange(),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(formatToTime(repportProvider.dateFrom)),
                    ),
                  ),
                  const Text('à'),
                  Expanded(
                    child: Center(
                      child: Text(formatToTime(repportProvider.dateTo)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
 */
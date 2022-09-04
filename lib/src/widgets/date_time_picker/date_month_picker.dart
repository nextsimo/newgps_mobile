import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../utils/styles.dart';
import '../../ui/repport/rapport_provider.dart';
import 'package:provider/provider.dart';

class DateMonthPicker extends StatelessWidget {
  const DateMonthPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RepportProvider provider = Provider.of<RepportProvider>(context);
    return InkWell(
      onTap: () async {
        DateTime? datetTime = await showMonthPicker(
          context: context,
          initialDate: DateTime.now(),
          locale: const Locale('fr', 'FR'),
          lastDate: DateTime.now(),
        );

        log("$datetTime");
        if (datetTime != null) {
          provider.selectedDateMonth = datetTime;
        }
      },
      child: Container(
        width: 140,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: Text(
            '${provider.selectedDateMonth.month}/${provider.selectedDateMonth.year}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppConsts.mainColor,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

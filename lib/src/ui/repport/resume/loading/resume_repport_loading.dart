import 'package:flutter/material.dart';
import '../../../../services/newgps_service.dart';
import '../../../../utils/styles.dart';
import 'package:provider/provider.dart';

import 'resume_repport_loding_provider.dart';

class ResumeRepportLoading extends StatelessWidget {
  final int milliseconds;
  const ResumeRepportLoading({super.key, this.milliseconds = 16});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResumeReportLoadingProvider>.value(
        value: NewgpsService.loading,
        builder: (context, __) {
          ResumeReportLoadingProvider provider =
              Provider.of<ResumeReportLoadingProvider>(context, listen: false);
          provider.globalInit();
          return Consumer<ResumeReportLoadingProvider>(builder: (context, p, __) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 350,
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      value: provider.value,
                      color: AppConsts.mainColor,
                      backgroundColor: AppConsts.mainColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(provider.value * 100).toInt()} %',
                  )
                ],
              ),
            );
          });
        });
  }
}

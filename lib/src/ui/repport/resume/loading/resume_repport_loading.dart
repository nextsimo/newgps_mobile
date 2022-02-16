import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import 'resume_repport_loding_provider.dart';

class ResumeRepportLoading extends StatelessWidget {
  const ResumeRepportLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResumeReportLoadingProvider(),
      builder: (context, __) {
        ResumeReportLoadingProvider provider = Provider.of<ResumeReportLoadingProvider>(context);
        return  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value:  provider.value,
                  color: AppConsts.mainColor,
                  backgroundColor: AppConsts.mainColor.withOpacity(0.4),

                ),
              ),
              const SizedBox(height: 10),
              Text('${(provider.value * 100).toInt()} %',)
            ],
          ),
        );
      }
    );
  }
}

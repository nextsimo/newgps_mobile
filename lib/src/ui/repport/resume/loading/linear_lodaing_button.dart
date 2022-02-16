import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'resume_repport_loding_provider.dart';

class LinearLoadingButton extends StatelessWidget {
  const LinearLoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResumeReportLoadingProvider>(
        create: (_) => ResumeReportLoadingProvider(),
        builder: (context, __) {
          ResumeReportLoadingProvider provider =
              Provider.of<ResumeReportLoadingProvider>(context, listen: false);
          return StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 13), (_) {
                provider.replay();
              }),
              builder: (context, __) {
                          ResumeReportLoadingProvider provider =
              Provider.of<ResumeReportLoadingProvider>(context);
                return Center(
                  child: SizedBox(
                    width: 184,
                    child: LinearProgressIndicator(
                      value: provider.value,
                      color: Colors.red,
                      backgroundColor: Colors.red.withOpacity(0.4),
                    ),
                  ),
                );
              });
        });
  }
}

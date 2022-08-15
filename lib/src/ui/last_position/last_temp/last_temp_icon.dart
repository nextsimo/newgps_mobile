import 'package:flutter/material.dart';
import 'package:newgps/src/ui/last_position/last_temp/last_temp_provider.dart';
import 'package:newgps/src/ui/last_position/last_temp/last_temp_view.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import '../last_position_provider.dart';

class LastTempIcon extends StatelessWidget {
  const LastTempIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*         return ChangeNotifierProvider<LastTempProvider>(
        create: (context) => LastTempProvider(),
        builder: (context, snapshot) {
          // watch the provider
          LastTempProvider provider = context.read<LastTempProvider>();
          return StreamBuilder<Object>(
              stream: Stream.periodic(const Duration(seconds: 20), (_) async {
                return provider.fetchLastTempRepport();
              }), */

    return ChangeNotifierProvider<LastTempProvider>(
      create: (_) => LastTempProvider(),
      builder: (BuildContext context, __) {
        LastTempProvider provider = context.read<LastTempProvider>();
        bool fetchGroupes = context.select<LastPositionProvider, bool>(
            (p) => p.markersProvider.fetchGroupesDevices);
        if (fetchGroupes) {
          return const SizedBox();
        }
        return StreamBuilder<Object>(
          stream: Stream.periodic(const Duration(seconds: 10), (_) async {
            return provider.fetchLastTempRepport();
          }),
          builder: (context, snapshot) {
            context.watch<LastTempProvider>();
            final model = provider.model;
            if (model == null) {
              return const SizedBox();
            }
            return Center(
              child: Container(
                height: 30,
                width: 40,
                padding: const EdgeInsets.all(1),
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppConsts.blue,
                ),
                child: Center(
                  child: Text(
                    "${model.temperature1}°c",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void showSideSheet({
  required BuildContext context,
  bool rightSide = true,
}) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Align(
        alignment: (rightSide ? Alignment.centerRight : Alignment.centerLeft),
        child: const LastTempView(),
      );
    },
    transitionBuilder: (context, animation1, animation2, child) {
      return SlideTransition(
        position: Tween(
                begin: Offset((rightSide ? 1 : -1), 0), end: const Offset(0, 0))
            .animate(animation1),
        child: child,
      );
    },
  );
}

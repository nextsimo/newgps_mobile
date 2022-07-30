import 'package:flutter/material.dart';
import 'package:newgps/src/ui/last_position/last_temp/last_temp_view.dart';
import 'package:provider/provider.dart';

import '../last_position_provider.dart';

class LastTempIcon extends StatelessWidget {
  const LastTempIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool fetchGroupes = context.select<LastPositionProvider, bool>(
        (p) => p.markersProvider.fetchGroupesDevices);
    if (fetchGroupes) {
      return const SizedBox();
    }
    return IconButton(
      onPressed: () {
        showSideSheet(
          context: context,
        );
      },
      icon: const Icon(
        Icons.thermostat,
        color: Colors.red,
      ),
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

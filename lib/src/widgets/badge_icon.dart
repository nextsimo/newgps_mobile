import 'package:flutter/material.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SavedAcountProvider, int>(
      selector: (_, p) => p.numberOfNotif,
      builder: (_, int count, __) {
        if (count == 0) {
          return const SizedBox();
        } else if (count > 99) {
          return CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            child: Center(
              child: Text(
                '$count+',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          );
        }
        return CircleAvatar(
          radius: 13,
          backgroundColor: Colors.red,
          child: Center(
            child: Text(
              '$count',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

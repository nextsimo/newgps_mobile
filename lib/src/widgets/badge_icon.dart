import 'package:flutter/material.dart';
import '../ui/login/login_as/save_account_provider.dart';
import 'package:provider/provider.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SavedAcountProvider, int>(
      selector: (_, p) => p.numberOfNotif,
      builder: (_, int count, __) {
        if (count == 0) {
          return const SizedBox();
        }

        return CircleAvatar(
          radius: 13,
          backgroundColor: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
    );
  }
}

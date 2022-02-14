import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/navigation/bottom_app_bar/bottom_navigatiom_bar.dart';
import 'badge_icon.dart';

class AlertTabBarItem extends StatelessWidget {
  final BottomAppBarItem item;
  final bool isSelected;
  const AlertTabBarItem(
      {Key? key, required this.item, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected
                ? AppConsts.mainColor.withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(color: AppConsts.mainColor, width: 2.0),
          ),
          child: Tab(
            height: 70,
            iconMargin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/${item.icon}.svg',
                  height: 16,
                ),
                const SizedBox(height: 5),
                Text(
                  item.label,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 9.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: -5.2,
          right: -3,
          child: BadgeIcon(),
        ),
      ],
    );
  }
}

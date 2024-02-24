import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/styles.dart';
import '../ui/navigation/bottom_app_bar/bottom_navigatiom_bar.dart';
import 'badge_icon.dart';

class AlertTabBarItem extends StatelessWidget {
  final BottomAppBarItem item;
  final bool isSelected;
  const AlertTabBarItem(
      {super.key, required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.miniradius),
            color: Colors.white,
            border: Border.all(
                color: isSelected ? AppConsts.mainColor : Colors.transparent,
                width: 2.0),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
            ],
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

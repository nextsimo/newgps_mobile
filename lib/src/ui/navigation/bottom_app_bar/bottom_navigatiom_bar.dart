import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newgps/src/ui/last_position/last_position_provider.dart';
import 'package:provider/provider.dart';
import '../../../services/newgps_service.dart';
import '../../../utils/styles.dart';
import '../../../widgets/alert_icon_widget.dart';

class CustomBottomNavigatioBar extends StatefulWidget {
  final PageController pageController;
  const CustomBottomNavigatioBar({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CustomBottomNavigatioBar> createState() =>
      _CustomBottomNavigatioBarState();
}

class _CustomBottomNavigatioBarState extends State<CustomBottomNavigatioBar> {
  final List<BottomAppBarItem> _items = [
    BottomAppBarItem(icon: 'last_position', label: 'Position', index: 0),
    BottomAppBarItem(icon: 'map_par_vehicule', label: 'Historique', index: 1),
    BottomAppBarItem(icon: 'report', label: 'Rapport', index: 2),
    BottomAppBarItem(icon: 'notification', label: 'Alerte', index: 3),
    BottomAppBarItem(icon: 'geozone', label: 'Geozone', index: 4),
    BottomAppBarItem(icon: 'user', label: 'Utilisateur', index: 5),
    BottomAppBarItem(icon: 'matricule', label: 'Matricule', index: 6),
    BottomAppBarItem(icon: 'temp', label: 'Température', index: 7),
    BottomAppBarItem(icon: 'driver', label: 'Conduite', index: 9),
    BottomAppBarItem(icon: 'cam', label: 'Caméra', index: 10),
  ];

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_pageControllerListner);
  }

  void _pageControllerListner() {
    _selectedIndex = widget.pageController.page!.toInt();
    setState(() {});
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageControllerListner);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigatioBar oldWidget) {
    // ignore: invalid_use_of_protected_member
    if (!widget.pageController.hasListeners) {
      widget.pageController.addListener(_pageControllerListner);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, or) {
      bool isPortrait = or == Orientation.portrait;
      Size size = MediaQuery.of(context).size;
      final lastPositionProvider = context.read<LastPositionProvider>();
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppConsts.mainradius)),
        ),
        child: SafeArea(
          left: false,
          right: false,
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConsts.mainradius),
              ),
            ),
            child: GridView(
              shrinkWrap: true,
              padding:  EdgeInsets.fromLTRB(10, 10.h, 10, 5),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 5 : 10,
                childAspectRatio: isPortrait ? 1.4 : 2.0,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              children: _items.map((item) {
                return InkWell(
                  onTap: () async {
                    if (item.index == widget.pageController.page) return;
                    if (item.index == 0) {
                      lastPositionProvider.handleZoomCamera();
                    }
                    widget.pageController.jumpToPage(item.index);
                    //await playAudio(_items.elementAt(item.index).label);
                    navigationViewProvider.currentRoute =
                        _items.elementAt(item.index).label;
                  },
                  child: _BuildTabBarItem(
                    isSelected: item.index == _selectedIndex,
                    item: item,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

class _BuildTabBarItem extends StatelessWidget {
  final BottomAppBarItem item;
  final bool isSelected;

  const _BuildTabBarItem({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (item.icon == 'notification') {
      return AlertTabBarItem(
        isSelected: isSelected,
        item: item,
      );
    }

    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class BottomAppBarItem {
  int index;
  final String icon;
  final String label;

  BottomAppBarItem({required this.icon, required this.label, this.index = 0});
}

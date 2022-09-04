import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../login/login_as/save_account_provider.dart';
import '../../../widgets/alert_icon_widget.dart';
import 'package:provider/provider.dart';

import 'bottom_navigatiom_bar.dart';

class UserCustomBottomNavigatioBar extends StatefulWidget {
  final PageController pageController;

  const UserCustomBottomNavigatioBar({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<UserCustomBottomNavigatioBar> createState() =>
      _UserCustomBottomNavigatioBarState();
}

class _UserCustomBottomNavigatioBarState
    extends State<UserCustomBottomNavigatioBar> {
  @override
  void initState() {
    super.initState();
    _initItems();

    widget.pageController.addListener(_pageControllerListner);
  }

  late List<BottomAppBarItem> _items;

  void _initItems() {
    SavedAcountProvider pro =
        Provider.of<SavedAcountProvider>(context, listen: false);
    _items = [
      if (pro.userDroits.droits[1].read)
        BottomAppBarItem(icon: 'last_position', label: 'Position'),
      if (pro.userDroits.droits[2].read)
        BottomAppBarItem(
            icon: 'map_par_vehicule', label: 'Historique', index: 1),
      if (pro.userDroits.droits[3].read)
        BottomAppBarItem(icon: 'report', label: 'Rapport', index: 2),
      if (pro.userDroits.droits[4].read)
        BottomAppBarItem(icon: 'notification', label: 'Alerte', index: 3),
      if (pro.userDroits.droits[5].read)
        BottomAppBarItem(icon: 'geozone', label: 'Géozone', index: 4),
      if (pro.userDroits.droits[7].read)
        BottomAppBarItem(icon: 'matricule', label: 'Matricule', index: 5),
      if (pro.userDroits.droits[8].read)
        BottomAppBarItem(icon: 'cam', label: 'Caméra', index: 6),
      if (pro.userDroits.droits[9].read)
        BottomAppBarItem(icon: 'gestion', label: 'Gestion', index: 7),
      if (pro.userDroits.droits[10].read)
        BottomAppBarItem(icon: 'driver', label: 'Conduite', index: 8),
    ];

    int _index = -1;
    for (var element in _items) {
      _index++;

      element.index = _index;
    }
  }

  int _selectedIndex = 0;

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
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, or) {
      bool isPortrait = or == Orientation.portrait;
      Size size = MediaQuery.of(context).size;
      return Container(
        color: Colors.white,
        child: SafeArea(
          left: false,
          right: false,
          child: Container(
            width: size.width,
            color: Colors.white,
            child: GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 5 : 10,
                childAspectRatio: isPortrait ? 1.4 : 2.0,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              children: _items.map((item) {
                return InkWell(
                  onTap: () {
                    widget.pageController.jumpToPage(item.index);
                    playAudio(_items.elementAt(item.index).label);
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
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? AppConsts.mainColor.withOpacity(0.2)
            : Colors.transparent,
        border: Border.all(color: AppConsts.mainColor, width: 2.0),
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

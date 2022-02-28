import 'package:flutter/material.dart';
import 'package:newgps/src/utils/device_size.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/badge_icon.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class AlertView extends StatelessWidget {
  const AlertView({Key? key}) : super(key: key);

  final List<_AlertItem> _items = const [
    _AlertItem(
        icon: IconData(0xe800, fontFamily: 'speed'),
        label: 'Vitesse',
        page: '/speed',
        inDev: false),
    _AlertItem(
        icon: Icons.ev_station_rounded,
        label: 'Carburant',
        page: '/fuel',
        inDev: false),
    _AlertItem(
        icon: Icons.battery_charging_full,
        label: 'Batterie',
        page: '/battery',
        inDev: false),
    _AlertItem(
      icon: Icons.dangerous,
      label: 'Demarage',
      page: '/startup',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.verified_user_rounded,
      label: 'Immobilisation',
      page: '/imobility',
      inDev: false,
    ),
    _AlertItem(
      icon: Icons.radar,
      label: 'Capot',
      page: '/hood',
      inDev: false,
    ),
    _AlertItem(
        icon: Icons.stacked_line_chart_sharp,
        label: 'Vidange',
        page: '/oil_change',
        inDev: false),
            _AlertItem(
      icon: Icons.car_repair_sharp,
      label: 'Dépannage',
      page: '/towing',
      inDev: false,
    ),
/*     _AlertItem(
        icon: Icons.radio_button_on_sharp,
        label: 'Radar',
        page: '/radar',
        inDev: false), */

    _AlertItem(
        icon: Icons.fireplace,
        label: 'Température',
        page: '/temp',
        inDev: false),
/*     _AlertItem(
        icon: Icons.flash_off_outlined,
        label: 'Débranchement',
        page: '/debranchement',
        inDev: false),
    _AlertItem(
        icon: Icons.edit_road_rounded,
        label: 'Autoroute',
        page: '/highway',
        inDev: false), */
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: _isPortrait ? 8 : 6),
        width: size.width,
        height: DeviceSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              right: false,
              top: false,
              bottom: false,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: MainButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/historics'),
                      label: 'Historiques',
                      width: 110,
                      height: _isPortrait ? 35 : 27,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  const Positioned(right: -8, top: -4, child: BadgeIcon()),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(AppConsts.outsidePadding,
                    AppConsts.outsidePadding, AppConsts.outsidePadding, 150),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 130,
                    childAspectRatio: 1.26,
                    crossAxisSpacing: AppConsts.outsidePadding,
                    mainAxisSpacing: AppConsts.outsidePadding),
                children: _items
                    .map<_AlertCatd>(
                      (item) => _AlertCatd(alertItem: item),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem {
  final String label;
  final String page;
  final IconData icon;
  final bool inDev;

  const _AlertItem(
      {required this.label,
      required this.page,
      required this.icon,
      this.inDev = true});
}

class _AlertCatd extends StatelessWidget {
  final _AlertItem alertItem;
  const _AlertCatd({Key? key, required this.alertItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!alertItem.inDev) {
          Navigator.of(context).pushNamed(alertItem.page);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            border: Border.all(color: AppConsts.mainColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 10),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Icon(alertItem.icon, color: AppConsts.mainColor, size: 17),
            const SizedBox(height: 10),
            Text(
              alertItem.label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (alertItem.inDev)
              const Text('En cours...',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

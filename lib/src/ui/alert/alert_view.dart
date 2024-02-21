import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/device_size.dart';
import '../../utils/styles.dart';
import '../navigation/top_app_bar.dart';
import '../../widgets/badge_icon.dart';
import '../../widgets/buttons/main_button.dart';

class AlertView extends StatelessWidget {
  const AlertView({Key? key}) : super(key: key);

  final List<_AlertItem> _items = const [
    _AlertItem(
        icon: FontAwesomeIcons.gauge,
        label: 'Vitesse',
        page: '/speed',
        inDev: false),
    _AlertItem(
        icon: FontAwesomeIcons.plug,
        label: 'Alimentation',
        page: '/battery',
        inDev: false),
    _AlertItem(
      // start vehicle
      icon: FontAwesomeIcons.carOn,
      label: 'Démarrage',
      page: '/startup',
      inDev: false,
    ),
    _AlertItem(
      // start stop icon
      icon: FontAwesomeIcons.carSide,
      label: 'Immobilisation',
      page: '/imobility',
      inDev: false,
    ),
    _AlertItem(
      icon: FontAwesomeIcons.carCrash,
      label: 'Capot',
      page: '/hood',
      inDev: false,
    ),
    _AlertItem(
        // oil change
        icon: FontAwesomeIcons.oilCan,
        label: 'Vidange',
        page: '/oil_change',
        inDev: false),
    _AlertItem(
      // towing icon
      icon: FontAwesomeIcons.truckPickup,
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
        icon: FontAwesomeIcons.thermometerHalf,
        label: 'Température',
        page: '/temp',
        inDev: false),
/*     _AlertItem(
      icon: Icons.car_crash_sharp,
      label: 'Parking',
      page: '/parking',
      inDev: false,
    ), */
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
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: isPortrait ? 8 : 6),
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
                      height: isPortrait ? 35 : 27,
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
                  mainAxisSpacing: AppConsts.outsidePadding,
                ),
                children: _items
                    .map<_AlertCatd>((item) => _AlertCatd(alertItem: item))
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
            Icon(alertItem.icon, color: AppConsts.mainColor, size: 20),
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

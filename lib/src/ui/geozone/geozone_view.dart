import 'package:flutter/material.dart';
import '../../models/geozne_sttings_alert.dart';
import '../../models/geozone.dart';
import '../../services/firebase_messaging_service.dart';
import '../../utils/styles.dart';
import '../login/login_as/save_account_provider.dart';
import '../navigation/top_app_bar.dart';
import '../../widgets/buttons/log_out_button.dart';
import '../../widgets/buttons/main_button.dart';
import '../../widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';
import 'geozone_provider.dart';

class GeozoneView extends StatelessWidget {
  const GeozoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<FirebaseMessagingService,
            GeozoneProvider>(
        update: (_, m, u) => GeozoneProvider(m: m),
        create: (_) => GeozoneProvider(),
        builder: (context, snapshot) {
          var droit = Provider.of<SavedAcountProvider>(context, listen: false)
              .userDroits
              .droits[5];
          GeozoneProvider provider = Provider.of<GeozoneProvider>(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(),
            body: InteractiveViewer(
              child: SafeArea(
                right: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Builder(builder: (context) {
                      MediaQueryData mediaQuery = MediaQuery.of(context);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: mediaQuery.orientation == Orientation.portrait
                              ? mediaQuery.size.width * 1.55
                              : mediaQuery.size.width * 0.94,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SearchWidget(
                                    autoFocus: false,
                                    hint: 'Chercher…',
                                    onChnaged: (_) async {
                                      await provider.fetchGeozones(search: _);
                                    },
                                  ),
                                  if (droit.write)
                                    MainButton(
                                      width: 120,
                                      height: 30,
                                      onPressed: () =>
                                          provider.showAddDialog(context),
                                      label: 'Ajouter une zone',
                                      fontSize: 10,
                                    ),
                                  const SizedBox(width: 3),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppConsts.mainColor,
                                          width: AppConsts.borderWidth),
                                      borderRadius: BorderRadius.circular(
                                          AppConsts.mainradius),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Activer alerte geozone',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(width: 6),
                                        Selector<GeozoneProvider,
                                            GeozoneSttingsAlert?>(
                                          builder: (_, settings, __) {
                                            if (settings == null) {
                                              return const SizedBox();
                                            }
                                            return SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: Switch(
                                                  value: settings.isActive,
                                                  onChanged: droit.write
                                                      ? provider.updateSettings
                                                      : null,
                                                  activeColor:
                                                      AppConsts.mainColor),
                                            );
                                          },
                                          selector: (_, provider) =>
                                              provider.geozoneSttingsAlert,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const LogoutButton(),
                            ],
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 255,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1.3),
                          itemCount: provider.geozones.length,
                          itemBuilder: (_, int index) {
                            GeozoneModel geozone =
                                provider.geozones.elementAt(index);
                            return GeozoneCard(geozone: geozone);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class GeozoneCard extends StatelessWidget {
  const GeozoneCard({
    Key? key,
    required this.geozone,
  }) : super(key: key);

  final GeozoneModel geozone;

  @override
  Widget build(BuildContext context) {
    final GeozoneProvider provider =
        Provider.of<GeozoneProvider>(context, listen: false);
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[5];
    return InkWell(
      onTap: () => provider.onClickUpdate(geozone, context, readonly: true),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          border: Border.all(width: 1.5, color: AppConsts.mainColor),
          image: DecorationImage(
            image: NetworkImage(geozone.mapImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConsts.mainradius),
                color: Colors.black.withOpacity(0.4),
              ),
              child: Text(
                geozone.description,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white, fontSize: 10),
              ),
            ),
            if (droit.write)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainButton(
                    width: 83,
                    height: 25,
                    fontSize: 10,
                    onPressed: () => provider.onClickUpdate(geozone, context),
                    label: 'Modifier',
                  ),
                  MainButton(
                    backgroundColor: Colors.red,
                    width: 83,
                    height: 25,
                    fontSize: 10,
                    onPressed: () {
                      provider.deleteGeozone(context, geozone.geozoneId);
                    },
                    label: 'Supprimer',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

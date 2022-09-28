import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/account.dart';
import '../../services/geozone_service.dart';
import '../../services/newgps_service.dart';
import '../../utils/device_size.dart';
import '../login/login_as/save_account_provider.dart';
import '../../utils/locator.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'bottom_app_bar/bottom_navigatiom_bar.dart';
import 'bottom_app_bar/user_bottom_navigation_bar.dart';

class CustomNavigationView extends StatelessWidget {
  CustomNavigationView({Key? key}) : super(key: key);
  final PageController myController = PageController();
  @override
  Widget build(BuildContext context) {
    DeviceSize.init(context);
    locator<GeozoneService>().fetchGeozoneFromApi();
    navigationViewProvider.pageController = myController;
    Account? account = shared.getAccount();
    resumeRepportProvider.fetchDataFromOutside();

    NewgpsService.messaging.init();

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: MultiProvider(
        providers: [
          Provider.value(value: NewgpsService.messaging),
          Provider.value(value: navigationViewProvider),
        ],
        builder: (BuildContext context, __) {
          SavedAcountProvider pro =
              Provider.of<SavedAcountProvider>(context, listen: false);
          pro.checkNotifcation();
          return UpgradeAlert(
            upgrader: Upgrader(
              debugDisplayOnce: false,
              canDismissDialog: false,
              dialogStyle: UpgradeDialogStyle.material,
              messages: UpgraderMessages(code: 'fr'),
              debugDisplayAlways: false,
              shouldPopScope: () => false,
              onLater: () => false,
              onIgnore: () => false,
              showReleaseNotes: true,
              showIgnore: false,
              showLater: false,
            ),
/*             messages: UpgraderMessages(code: 'fr'),
            countryCode: 'MA',
            showIgnore: false,
            shouldPopScope: () => false,
            showLater: false,
            canDismissDialog: false, */
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: myController,
                children: pro.buildPages(),
              ),
              bottomNavigationBar: (account!.account.userID == null ||
                      account.account.userID!.isEmpty)
                  ? CustomBottomNavigatioBar(
                      pageController: myController,
                    )
                  : UserCustomBottomNavigatioBar(
                      pageController: myController,
                    ),
            ),
          );
        },
      ),
    );
  }
}

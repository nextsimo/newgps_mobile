import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../services/newgps_service.dart';
import '../../utils/utils.dart';
import '../connected_device/connected_device_button.dart';
import '../connected_device/connected_device_view.dart';
import '../../utils/functions.dart';
import '../../utils/styles.dart';
import '../../widgets/buttons/main_button.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final void Function()? onTap;
  final List<Widget> actions;

  const CustomAppBar(
      {Key? key,
      this.height = kToolbarHeight,
      this.actions = const [],
      this.onTap})
      : super(
          key: key,
          child: const SizedBox(),
          preferredSize: const Size.fromHeight(kToolbarHeight),
        );

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AppBar(
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppConsts.mainradius),
              ),
            ),
            centerTitle: true,
            actions: actions,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false, // hides leading widget
            leading: Row(
              children: [
                const SizedBox(width: 10),
                Hero(
                  tag: Utils.logoHeroTag,
                  child: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/logo-200.png',
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const _BuildCallWidget(),
          const _BuildAccountName(),
        ],
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logo-200.png',
                  width: 36,
                ),
                Row(
                  children: actions,
                )
              ],
            ),
            const _BuildCall(),
          ],
        ),
      ),
    );
  }
}

class _BuildAccountName extends StatelessWidget {
  const _BuildAccountName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account? account = shared.getAccount();
    String name;

    if (account!.account.userID != null && account.account.userID!.isNotEmpty) {
      name = account.account.userID ?? '';
    } else {
      name = account.account.accountId ?? '';
    }
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => const ConnectedDeviceView(),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 0, top: MediaQuery.of(context).padding.top * 0.2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppConsts.mainColor, width: 1.4),
                borderRadius: BorderRadius.circular(AppConsts.mainradius),
              ),
              child: Text(
                name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const ConnectedDeviceButton(),
          ],
        ),
      ),
    );
  }
}

class _BuildCallWidget extends StatelessWidget {
  const _BuildCallWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: MainButton(
          width: 165,
          height: Platform.isIOS ? 35 : 26,
          icon: Icons.call,
          onPressed: () {
            showCallService(context);
          },
          label: 'Service aprés ventes',
        ),
      ),
    );
  }
}

class _BuildCall extends StatelessWidget {
  const _BuildCall({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BuildAccountName(),
          MainButton(
            width: 300,
            height: 30,
            icon: Icons.call,
            onPressed: () {
              showCallService(context);
            },
            label: 'Service aprés ventes',
          ),
        ],
      ),
    );
  }
}

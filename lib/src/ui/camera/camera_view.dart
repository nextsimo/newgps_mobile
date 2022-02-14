import 'package:flutter/material.dart';
import 'package:newgps/src/models/device.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/camera/camera_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/inputs/auto_search_all.dart';
import 'package:provider/provider.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CameraProvider>(
        create: (_) => CameraProvider(),
        builder: (context, __) {
          final CameraProvider provider = Provider.of<CameraProvider>(context);

          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSearchWithAllWidget(
                      clearTextController: provider.auto.clear,
                      controller: provider.auto.controller,
                      handleSelectDevice: provider.auto.handleSelectDevice,
                      initController: provider.auto.initController,
                      onClickAll: provider.auto.onClickAll,
                      onSelectDevice: provider.auto.onTapDevice,
                    ),

                    const LogoutButton(),
                  ],
                ),
                if (provider.devices.length == 1)
                  SafeArea(
                    left: true,
                    right: true,
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _BuildCameraCard(
                        device: provider.devices.elementAt(0),
                        height: 230,
                      ),
                    ),
                  ),
                if (provider.devices.length > 1)
                  Expanded(
                    child: SafeArea(
                      right: false,
                      top: false,
                      bottom: false,
                      child: GridView.builder(
                        itemCount: provider.devices.length,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 160),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 210,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.3),
                        itemBuilder: (_, int index) => _BuildCameraCard(
                          device: provider.devices.elementAt(index),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

class _BuildCameraCard extends StatelessWidget {
  final Device device;
  final double? height;
  const _BuildCameraCard({
    Key? key,
    required this.device,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConsts.mainColor, width: 2.2),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/driver.jpeg'),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black.withOpacity(0.6),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: Text(
          device.description,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

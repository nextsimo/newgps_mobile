import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/device_icon_model.dart';
import '../../services/newgps_service.dart';
import '../../models/device.dart';
import '../../utils/styles.dart';

class IconChangeView extends StatelessWidget {
  final Device selectedDevice;
  const IconChangeView({Key? key, required this.selectedDevice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(AppConsts.mainradius),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => IconsList(
                  selectedDevice: selectedDevice,
                ));
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: boxDecoration,
        child: Row(
          children: const [
            Text(
              'Changer l\'icône',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class IconsList extends StatelessWidget {
  final Device selectedDevice;
  const IconsList({Key? key, required this.selectedDevice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Choissisez l\'icône',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CloseButton(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: deviceProvider.icons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final icon = deviceProvider.icons[index];
              return _BuildIconWidget(
                iconModel: icon,
                deviceId: selectedDevice.deviceId,
                isSelected: selectedDevice.deviceIcon == icon.name,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BuildIconWidget extends StatelessWidget {
  final DeviceIconModel iconModel;
  final bool isSelected;
  final String deviceId;
  const _BuildIconWidget({
    Key? key,
    required this.iconModel, required this.isSelected, required this.deviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => deviceProvider.changeIcon(name: iconModel.name, deviceId: deviceId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          border: Border.all(
            color: isSelected ? AppConsts.mainColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Center(
          child: Image.memory(
            base64Decode(iconModel.iconBase64),
            height: 35,
            width: 35,
          ),
        ),
      ),
    );
  }
}

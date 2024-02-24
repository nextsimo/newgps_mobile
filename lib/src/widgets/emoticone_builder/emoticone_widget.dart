import 'package:flutter/material.dart';
import '../../utils/device_size.dart';
import '../../utils/styles.dart';
import 'emoticon_provider.dart';
import 'package:provider/provider.dart';

class EmoticonWidget extends StatelessWidget {
  const EmoticonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmoticonProvider>(
        create: (_) => EmoticonProvider(),
        builder: (BuildContext context, __) {
          final EmoticonProvider provider = Provider.of(context, listen: false);
          return InkWell(
            onTap: () => provider.showEmotsDialog(context),
            child: SizedBox(
              width: DeviceSize.width,
              height: 40,
              child: Row(
                children: [
                  const Icon(Icons.add_location_alt_rounded,
                      color: Colors.red, size: 15),
                  const SizedBox(width: 5),
                  const Text(
                    'Emoticone:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 180,
                    height: 27,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConsts.mainradius),
                        color: Colors.white,
                        border: Border.all(color: AppConsts.mainColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.asset('assets/icons/n-r.png',
                                  width: 20, height: 20),
                              const SizedBox(width: 10),
                              const Text(
                                'Défaut:',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

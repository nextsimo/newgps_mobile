import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newgps/src/utils/functions.dart';
import '../../utils/styles.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCallService(context),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.phone,
              color: Colors.green,
              size: 15.r,
            ),
            SizedBox(width: 12.w),
            Text(
              'Appeler Service Après Vente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );

/*     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.call_end,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                "Service après vente".toUpperCase(),
                style: const TextStyle(
                  letterSpacing: 1.25,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildPhone(tel: '06 62 78 26 94'),
          const SizedBox(height: 4),
          _buildPhone(tel: '‎05 22 30 48 10'),
          const SizedBox(height: 4),
          _buildPhone(tel: '06 61 59 93 92'),
        ],
      ),
    ); */
  }
}

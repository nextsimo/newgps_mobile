import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newgps/src/utils/functions.dart';
import '../../utils/styles.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({Key? key}) : super(key: key);

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

  Widget _buildPhone({required String tel}) {
    return GestureDetector(
      onTap: () => call(tel),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: Center(
          child: Container(
            width: 220,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConsts.mainradius),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConsts.mainradius),
                    color: AppConsts.mainColor,
                  ),
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                Text(
                  tel,
                  style: const TextStyle(
                    color: AppConsts.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

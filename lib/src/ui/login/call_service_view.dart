import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppConsts.mainColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.call_end),
              const SizedBox(width: 10),
              Text(
                "Service après vente".toUpperCase(),
                style: const TextStyle(
                  letterSpacing: 1.25,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPhone(tel: '06 62 78 26 94'),
          const SizedBox(height: 8),
          _buildPhone(tel: '‎05 22 30 48 10'),
          const SizedBox(height: 8),
          _buildPhone(tel: '06 61 59 93 92'),
        ],
      ),
    );
  }

  Widget _buildPhone({required String tel}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tel,
          style: const TextStyle(
              color: AppConsts.blue,
              decoration: TextDecoration.overline,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppConsts.mainColor,
          ),
          child: const Icon(
            Icons.call,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    );
  }
}

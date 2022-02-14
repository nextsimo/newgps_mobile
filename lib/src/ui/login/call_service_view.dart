import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';

class CallServiceView extends StatelessWidget {
  const CallServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Service après vente".toUpperCase(),
          style: const TextStyle(
            letterSpacing: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        _buildPhone(tel: '06 62 78 26 94'),
        const SizedBox(height: 6),
        _buildPhone(tel: '‎05 22 30 48 10'),
        const SizedBox(height: 6),
        _buildPhone(tel: '06 61 59 93 92'),
      ],
    );
  }

  Widget _buildPhone({required String tel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tel,
          style: const TextStyle(
            color: AppConsts.mainColor,
            decoration: TextDecoration.underline,
          ),
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
            )),
      ],
    );
  }
}

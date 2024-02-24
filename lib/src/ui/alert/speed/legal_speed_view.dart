import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LegalSpeedView extends StatelessWidget {
  const LegalSpeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Row _buildHeader() {
    return const Row(
          children: [
            Icon(
              FontAwesomeIcons.gaugeHigh,
              color: Colors.green,
            ),
             SizedBox(width: 10),
            Text(
              'Alert vitesse légale sur les routes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

          ],
        );
  }
}

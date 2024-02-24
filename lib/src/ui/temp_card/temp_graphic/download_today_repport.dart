import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/device.dart';
import '../temp_card_provider.dart';

class DownloadTodayRepport extends StatelessWidget {
  final Device device;
  const DownloadTodayRepport({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    // read provider
    final provider = context.read<TempCardProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Rapport du jour :',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Selector<TempCardProvider, bool>(
                selector: (_, provider) => provider.downloadingPdf,
                builder: (context, downloading, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () =>
                          provider.downloadTodayReport(device, 'pdf'),
                      icon: _buildDownloadIcon(
                          downloading, FontAwesomeIcons.filePdf),
                      color: Colors.white,
                    ),
                  );
                }),
            const SizedBox(width: 10),
            Selector<TempCardProvider, bool>(
                selector: (_, provider) => provider.downloadingXsl,
                builder: (context, downloading, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () =>
                          provider.downloadTodayReport(device, 'xsl'),
                      icon: _buildDownloadIcon(
                          downloading, FontAwesomeIcons.fileExcel),
                      color: Colors.white,
                    ),
                  );
                }),
          ],
        ),
      ],
    );
  }

  // build download icon
  Widget _buildDownloadIcon(bool loading, IconData icon) {
    if (loading == true) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );
    }
    return Icon(
      icon,
      color: Colors.white,
    );
  }
}

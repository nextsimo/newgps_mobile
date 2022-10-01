import 'package:flutter/material.dart';

class DownloadTodayRepport extends StatelessWidget {
  const DownloadTodayRepport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // button to download today repport
    return ElevatedButton(
      onPressed: () {
        // download today repport
        // provider.downloadTodayRepport();
      },
      child: const Text("Télécharger le rapport d'aujourd'hui"),
    );
  }
}
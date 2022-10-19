import 'package:flutter/material.dart';
import '../../services/newgps_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteVolumeWidget extends StatefulWidget {
  const DeleteVolumeWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeleteVolumeWidgetState createState() => _DeleteVolumeWidgetState();
}

class _DeleteVolumeWidgetState extends State<DeleteVolumeWidget> {
  @override
  void initState() {
    super.initState();

    _getInitVolumeState();
  }

  _getInitVolumeState() {
    double? res = shared.sharedPreferences?.getDouble('volume');
    volume = res ?? 1.0;
  }

  double volume = 1.0;

  @override
  Widget build(BuildContext context) {
    bool mute = volume == 1.0 ? false : true;
    //Orientation orientation = MediaQuery.of(context).orientation;
    return InkWell(
      onTap: () async {
        if (mute) {
          await NewgpsService.audioPlayer.setVolume(1);
          volume = 1.0;
        } else {
          await NewgpsService.audioPlayer.setVolume(0);
          volume = 0.0;
        }
        setState(() {});
        shared.sharedPreferences?.setDouble('volume', volume);
      },
      child: SizedBox(
        width: 35,
        height: 35,
        child: Center(
          child: Icon(
            mute ? Icons.volume_off_sharp : Icons.volume_up,
            color: Colors.black,
          ),
        ),

/*       child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            mute ? Icons.volume_off_sharp : Icons.volume_up,
          ),
          iconSize: 17,
          onPressed: () async {
            if (mute) {
              await NewgpsService.audioPlayer.setVolume(1);
              volume = 1.0;
            } else {
              await NewgpsService.audioPlayer.setVolume(0);
              volume = 0.0;
            }
            setState(() {});
            shared.sharedPreferences.setDouble('volume', volume);
          },
        ), */
      ),
    );
  }

  void setSharedPreferecences(double volume) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('volume', volume);
  }
}

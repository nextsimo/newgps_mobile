/* import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/ui/historic/historic_provider.dart';
import 'package:newgps/src/ui/historic/parking/parking_provider.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

class ShowAllMarkersButton extends StatelessWidget {
  const ShowAllMarkersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historicProvider = context.read<HistoricProvider>();
    return Positioned(
      top: 165.r.h,
      right: 5,
      child: Selector<ParkingProvider, bool>(
        selector: (_, p) => p.buttonClicked,
        builder: (context, bool isSelected,___) {
          return MainButton(
            backgroundColor: isSelected ? Colors.white: Colors.deepPurple,
            borderColor:  isSelected ? Colors.deepPurple: Colors.transparent,
            textColor: isSelected ? Colors.black: Colors.white,
            width: 112,
            height: 35,
            onPressed: historicProvider.showAllMarkers,
            label: 'Tous les points',
          );
        }
      ),
    );
  }
}
 */
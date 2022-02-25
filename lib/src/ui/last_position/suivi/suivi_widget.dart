import 'package:flutter/material.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';

import '../last_position_provider.dart';

class SuiviWidget extends StatelessWidget {
  const SuiviWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    LastPositionProvider lastPositionProvider =
        Provider.of<LastPositionProvider>(context);
    if (!lastPositionProvider.markersProvider.fetchGroupesDevices) {
      bool isEmpty = lastPositionProvider.polylines.isEmpty;
      if (orientation == Orientation.landscape) {
        return _SuiviWidgetLandscape(
            isEmpty: isEmpty, lastPositionProvider: lastPositionProvider);
      }
      return _SuiviWidgetPortrait(
          isEmpty: isEmpty, lastPositionProvider: lastPositionProvider);
    }
    return const SizedBox();
  }
}

class _SuiviWidgetLandscape extends StatelessWidget {
  const _SuiviWidgetLandscape({
    Key? key,
    required this.isEmpty,
    required this.lastPositionProvider,
  }) : super(key: key);

  final bool isEmpty;
  final LastPositionProvider lastPositionProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16)),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => isEmpty ? AppConsts.blue : Colors.white),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            onPressed: () => lastPositionProvider.buildRoutes(),
            child: Row(
              children: [
                lastPositionProvider.loadingRoute
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white))),
                      )
                    : lastPositionProvider.navigationStarted
                        ? const Icon(Icons.navigation, size: 18)
                        : Image.asset(
                            'assets/icons/map_arrow.png',
                            width: 13,
                            color: isEmpty ? Colors.white : Colors.blue,
                          ),
                const SizedBox(width: 2),
                Text(
                  isEmpty ? 'Itinéraire' : 'Démarrer',
                  style: TextStyle(
                    fontSize: 10,
                    color: isEmpty ? Colors.white : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuiviWidgetPortrait extends StatelessWidget {
  const _SuiviWidgetPortrait({
    Key? key,
    required this.isEmpty,
    required this.lastPositionProvider,
  }) : super(key: key);

  final bool isEmpty;
  final LastPositionProvider lastPositionProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => isEmpty ? AppConsts.blue : Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          onPressed: () => lastPositionProvider.buildRoutes(),
          child: Row(
            children: [
              lastPositionProvider.loadingRoute
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 1.2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))),
                    )
                  : lastPositionProvider.navigationStarted
                      ? const Icon(Icons.navigation, size: 18, color: Colors.blue)
                      : Image.asset(
                          'assets/icons/map_arrow.png',
                          width: 18,
                          color: isEmpty ? Colors.white : Colors.blue,
                        ),
              const SizedBox(width: 6),
              Text(
                isEmpty ? 'Itinéraire' : 'Démarrer',
                style: TextStyle(
                  fontSize: 12,
                  color: isEmpty ? Colors.white : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

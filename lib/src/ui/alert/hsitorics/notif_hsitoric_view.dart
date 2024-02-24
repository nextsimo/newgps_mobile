import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notif_hsitoric_model.dart';
import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../navigation/top_app_bar.dart';
import 'notif_historic_provider.dart';

class NotifHistoricView extends StatelessWidget {
  const NotifHistoricView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifHistoricPorvider>(
        create: (_) => NotifHistoricPorvider(),
        builder: (BuildContext context, __) {
          NotifHistoricPorvider porvider =
              Provider.of<NotifHistoricPorvider>(context, listen: false);
          porvider.initDevices(context);
          return Scaffold(
            appBar:
                const CustomAppBar(actions: [CloseButton(color: Colors.black)]),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel(),
                const SizedBox(height: 20),
                Container(height: 0.6, color: Colors.grey),
                Expanded(
                  child: SafeArea(
                    bottom: false,
                    top: false,
                    right: false,
                    child: Selector<NotifHistoricPorvider, bool>(
                        selector: (_, __) => __.loading,
                        builder: (_, histos, __) {
                          final histos = porvider.histos;
                          if (porvider.loading) {
                            return const Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppConsts.mainColor))),
                              ),
                            );
                          }

                          if (histos.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.hourglass_empty_rounded,
                                    size: 66,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pas historiques pour le moment',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: histos.length,
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 150),
                            itemBuilder: (_, int index) {
                              return _HistoricCard(
                                notifHistoric: histos.elementAt(index),
                              );
                            },
                            separatorBuilder: (_, __) => Container(
                              height: 0.6,
                              color: Colors.grey,
                              margin: const EdgeInsets.fromLTRB(74, 08, 0, 08),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildLabel() {
    return const SafeArea(
      bottom: false,
      top: false,
      right: false,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Historiques',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricCard extends StatelessWidget {
  final NotifHistoric notifHistoric;
  const _HistoricCard({required this.notifHistoric});

  @override
  Widget build(BuildContext context) {
    NotifHistoricPorvider provider =
        Provider.of<NotifHistoricPorvider>(context, listen: false);
    return GestureDetector(
      onTap: () => provider.navigateToDetaisl(context, model: notifHistoric),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppConsts.mainColor, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(provider.getIcon(notifHistoric.type),
                      color: AppConsts.mainColor, size: 19),
                  const SizedBox(height: 6),
                  Text(provider.getLabel(notifHistoric.type),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifHistoric.device,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notifHistoric.message,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    whatsapFormatOnlyTime(
                        notifHistoric.createdAt.add(const Duration(hours: 1))),
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (notifHistoric.countNotRead > 0)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            '${notifHistoric.countNotRead}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
/*                     Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Text(
                        '${notifHistoric.countNotRead}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

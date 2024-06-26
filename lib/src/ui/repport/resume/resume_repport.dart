import 'package:flutter/material.dart';
import '../../../models/device.dart';
import '../../../models/repport_resume_model.dart';
import '../../../services/newgps_service.dart';
import '../../driver_phone/driver_phone_provider.dart';
import 'loading/resume_repport_loading.dart';
import '../../../utils/functions.dart';
import '../../../utils/locator.dart';
import '../../../utils/styles.dart';
import 'resume_repport_provider.dart';
import 'package:provider/provider.dart';
import '../clickable_text_cell.dart';
import '../custom_devider.dart';
import '../rapport_provider.dart';
import '../text_cell.dart';

class BuildHead extends StatelessWidget {
  const BuildHead({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    ResumeRepportProvider repportProvider =
        Provider.of<ResumeRepportProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Matricule',
            flex: repportProvider.showDriver ? 5 : 6,
            ontap: repportProvider.updateOrderByMatricule,
            isSlected: repportProvider.selectedIndex == 1,
            isUp: repportProvider.orderByMatricule,
          ),
          if (resumeRepportProvider.showDriver)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const BuildDivider(height: 20),
                  BuildClickableTextCell(
                    'Chauffeur',
                    flex: 2,
                    ontap: repportProvider.updateOrderByDriverName,
                    isSlected: repportProvider.selectedIndex == 2,
                    isUp: repportProvider.orderByDriverName,
                  ),
                ],
              ),
            ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Km actuel',
            flex: 2,
            ontap: repportProvider.updateByCurrentDistance,
            isSlected: repportProvider.selectedIndex == 3,
            isUp: repportProvider.odrderByCurrentDistance,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Vitesse actuel',
            flex: 2,
            ontap: repportProvider.updateByCurrentSpeed,
            isSlected: repportProvider.selectedIndex == 4,
            isUp: repportProvider.odrderByCurrentSpeed,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Vitesse max',
            flex: 2,
            ontap: repportProvider.updateByMaxSpeed,
            isSlected: repportProvider.selectedIndex == 5,
            isUp: repportProvider.odrderByMaxSpeed,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Km parcouru',
            flex: 2,
            ontap: repportProvider.updateByDistance,
            isSlected: repportProvider.selectedIndex == 6,
            isUp: repportProvider.odrderByDistance,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Cons L/100Km',
            flex: 2,
            ontap: repportProvider.updateByCarbConsumation,
            isSlected: repportProvider.selectedIndex == 7,
            isUp: repportProvider.orderByCarbConsumation,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'N. carburant',
            flex: 2,
            ontap: repportProvider.updateByCurrentCarb,
            isSlected: repportProvider.selectedIndex == 8,
            isUp: repportProvider.orderByCurrentCarb,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'T. conduite',
            flex: 2,
            ontap: repportProvider.updateDrivingTime,
            isSlected: repportProvider.selectedIndex == 9,
            isUp: repportProvider.orderDrivingTime,
          ),
          const BuildDivider(height: 20),
          BuildClickableTextCell(
            'Adresse',
            flex: 8,
            ontap: repportProvider.updateByAdresse,
            isSlected: repportProvider.selectedIndex == 10,
            isUp: repportProvider.orderByAdresse,
          ),
          const BuildDivider(height: 20),
/*           BuildClickableTextCell(
            'Ville',
            flex: 2,
            ontap: repportProvider.updateByCity,
            isSlected: repportProvider.selectedIndex == 11,
            isUp: repportProvider.orderByCity,
          ),
          const BuildDivider(height: 20), */
          BuildClickableTextCell(
            'Date actualisation',
            flex: 4,
            ontap: repportProvider.updateByDateActualisation,
            isSlected: repportProvider.selectedIndex == 12,
            isUp: repportProvider.orderByDateActualisation,
          ),
          const BuildDivider(height: 20),
        ],
      ),
    );
  }
}

class ResumeRepport extends StatelessWidget {
  const ResumeRepport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RepportProvider repportProvider =
        Provider.of<RepportProvider>(context, listen: false);

    return ChangeNotifierProvider<ResumeRepportProvider>.value(
        value: resumeRepportProvider,
        builder: (context, snapshot) {
          ResumeRepportProvider resumeRepportProvider =
              Provider.of<ResumeRepportProvider>(context, listen: false);
          resumeRepportProvider.init(repportProvider);

          return Consumer<ResumeRepportProvider>(
            builder: (_, p, __) {
              if (p.resumes.isEmpty) {
                return const ResumeRepportLoading();
              }
              return _BuildTable(resumes: p.resumes);
            },
          );
/*           return Consumer<ResumeRepportProvider>(builder: (context, p, __) {
            return _BuildTable(resumes: p.resumes);
          }); */
        });
  }
}

class _BuildTable extends StatelessWidget {
  const _BuildTable({
    required this.resumes,
  });

  final List<RepportResumeModel> resumes;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BuildHead(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, int index) {
                RepportResumeModel repport = resumes.elementAt(index);
                return RepportRow(repport: repport);
              },
              itemCount: resumes.length,
            ),
          ),
        ],
      ),
    );
  }
}

class RepportRow extends StatelessWidget {
  const RepportRow({
    super.key,
    required this.repport,
  });

  final RepportResumeModel repport;

  @override
  Widget build(BuildContext context) {
    final resumeRepportProvider =
        Provider.of<ResumeRepportProvider>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppConsts.mainColor, width: AppConsts.borderWidth),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(height: 10),
          Expanded(
            flex: resumeRepportProvider.showDriver ? 5 : 6,
            child: InkWell(
              onTap: () {
                Device device = deviceProvider.devices.firstWhere(
                    (element) => element.deviceId == repport.deviceId);
                locator<DriverPhoneProvider>().checkPhoneDriver(
                  context: context,
                  device: device,
                  sDevice: device,
                  callNewData: () async {
                    await deviceProvider.fetchDevices();
                  },
                );
              },
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    BuildTextCell(repport.description),
                    const Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (resumeRepportProvider.showDriver)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const BuildDivider(height: 10),
                  BuildTextCell(repport.driverName, flex: 2),
                ],
              ),
            ),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.lastOdometerKm}', flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.lastValidSpeedKph}',
              flex: 2,
              color: Color.fromRGBO(
                  repport.colorR, repport.colorG, repport.colorB, 1.0)),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.maxSpeed}', flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.distance}', flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.carbConsomation}', flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell('${repport.carbNiveau}', flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell(repport.drivingTime, flex: 2),
          const BuildDivider(height: 10),
          BuildTextCell(repport.adresse, flex: 8),
/*           const BuildDivider(height: 10),
          BuildTextCell(repport.city, flex: 2), */
          const BuildDivider(height: 10),
          BuildTextCell(formatDeviceDate(repport.lastValideDate), flex: 4),
/*           const BuildDivider(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            child: MainButton(
              onPressed: () {},
              width: 74,
              height: 6,
              label: 'Redémarrer',
              fontSize: 5,
            ),
          ), */
          const BuildDivider(height: 10),
        ],
      ),
    );
  }
}



// write me function that connect to the sqliite database and return the data

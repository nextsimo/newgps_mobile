import 'package:flutter/material.dart';
import 'package:newgps/src/models/matricule.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/matricule/matricule_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/ui/repport/custom_devider.dart';
import 'package:newgps/src/ui/repport/text_cell.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

class MatriculeView extends StatelessWidget {
  const MatriculeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatriculeProvider>(
      create: (_) => MatriculeProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: const MatriculeDataView(),
    );
  }
}

class MatriculeDataView extends StatelessWidget {
  const MatriculeDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MatriculeProvider matriculeProvider =
        Provider.of<MatriculeProvider>(context);
    List<MatriculeModel> matricules = matriculeProvider.matricules;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: Colors.white,
        extendBody: true,
        body: InteractiveViewer(
          child: SafeArea(
            right: false,
            bottom: false,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SearchWidget(
                            hint: 'Entrer matricule',
                            onChnaged: matriculeProvider.search,
                          ),
                        ],
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(right: AppConsts.outsidePadding),
                        child: LogoutButton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (BuildContext context) {
                      bool isPortrait = MediaQuery.of(context).orientation ==
                          Orientation.portrait;
                      if (isPortrait) {
                        return _BuildTablePortrait(
                            size: size, matricules: matricules);
                      }

                      return _BuildTableLandscap(
                          size: size, matricules: matricules);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _BuildTablePortrait extends StatelessWidget {
  const _BuildTablePortrait({
    Key? key,
    required this.size,
    required this.matricules,
  }) : super(key: key);

  final Size size;
  final List<MatriculeModel> matricules;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 850,
          child: Column(
            children: [
              const BuildHead(),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: matricules.length,
                    itemBuilder: (_, int index) {
                      MatriculeModel matricule = matricules.elementAt(index);
                      return MatriculeRowContent(matricule: matricule);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class _BuildTableLandscap extends StatelessWidget {
  const _BuildTableLandscap({
    Key? key,
    required this.size,
    required this.matricules,
  }) : super(key: key);

  final Size size;
  final List<MatriculeModel> matricules;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const BuildHead(),
          Expanded(
            child: SizedBox(
              width: size.width,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: matricules.length,
                itemBuilder: (_, int index) {
                  MatriculeModel matricule = matricules.elementAt(index);
                  return MatriculeRowContent(matricule: matricule);
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class BuildHead extends StatelessWidget {
  const BuildHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[6];
    var borderSide = const BorderSide(
        color: AppConsts.mainColor, width: AppConsts.borderWidth);
    return Container(
      decoration: BoxDecoration(
        color: AppConsts.mainColor.withOpacity(0.2),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: Row(
        children: [
          const BuildDivider(height: 14),
          const BuildTextCell('N'),
          const BuildDivider(height: 14),
          const BuildTextCell('WW', flex: 3),
          const BuildDivider(height: 14),
          const BuildTextCell('Marque', flex: 2),
          const BuildDivider(height: 14),
          const BuildTextCell('Couleur', flex: 2),
          const BuildDivider(height: 14),
          const BuildTextCell('Matricule', flex: 3),
          const BuildDivider(height: 14),
          const BuildTextCell('Nom chauffeur', flex: 3),
          const BuildDivider(height: 14),
          const BuildTextCell('Téléphone 1', flex: 3),
          const BuildDivider(height: 14),
          const BuildTextCell('Téléphone 2', flex: 3),
          const BuildDivider(height: 14),
          const BuildTextCell('Kilométrage', flex: 2),
          const BuildDivider(height: 14),
          const BuildTextCell('Réservoir en litre', flex: 3),
          if (droit.write) const BuildDivider(height: 14),
          if (droit.write)
            const SizedBox(
                width: 90,
                child: Center(
                  child: Text(
                    'Enregistrement',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                  ),
                )),
          const BuildDivider(height: 14),
        ],
      ),
    );
  }
}

class MatriculeRowContent extends StatelessWidget {
  const MatriculeRowContent({
    Key? key,
    required this.matricule,
  }) : super(key: key);

  final MatriculeModel matricule;

  @override
  Widget build(BuildContext context) {
    MatriculeProvider provider =
        Provider.of<MatriculeProvider>(context, listen: false);
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[6];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppConsts.mainColor,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const BuildDivider(height: 14),

          BuildTextCell('${matricule.index}'),
          const BuildDivider(height: 14),
          EditableCell(
            content: matricule.vehicleId,
            onchanged: (_) => matricule.vehicleId = _,
            flex: 3,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: matricule.vehicleModel,
            onchanged: (_) => matricule.vehicleModel = _,
            flex: 2,
          ),
          const BuildDivider(height: 14),

          EditableCell(
            content: matricule.vehicleColor,
            onchanged: (_) => matricule.vehicleColor = _,
            flex: 2,
          ),
          const BuildDivider(height: 14),
          //BuildTextCell(matricule.description),
          EditableCell(
            content: matricule.description,
            onchanged: (_) => matricule.description = _,
            flex: 3,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: matricule.driverName,
            onchanged: (_) => matricule.driverName = _,
            flex: 3,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: matricule.phone1,
            onchanged: (_) => matricule.phone1 = _,
            flex: 3,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: matricule.phone2,
            onchanged: (_) => matricule.phone2 = _,
            flex: 3,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: '${matricule.lastOdometerKM}',
            onchanged: (_) => matricule.lastOdometerKM = double.parse(_),
            flex: 2,
          ),
          const BuildDivider(height: 14),
          EditableCell(
            content: '${matricule.fuelCapacity}',
            onchanged: (_) => matricule.fuelCapacity = int.parse(_),
            flex: 3,
          ),
          if (droit.write) const BuildDivider(height: 14),
          if (droit.write)
            Padding(
              padding: const EdgeInsets.all(1),
              child: MainButton(
                onPressed: () async =>
                    await provider.onSave(matricule, context),
                height: 12,
                label: 'Enregister',
                fontSize: 8,
                backgroundColor: Colors.green,
                width: 88,
              ),
            ),
          const BuildDivider(height: 14),
        ],
      ),
    );
  }
}

class EditableCell extends StatelessWidget {
  final String content;
  final int flex;
  final void Function(String val) onchanged;
  EditableCell(
      {Key? key, required this.content, required this.onchanged, this.flex = 1})
      : super(key: key);

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[6];
    _controller.text = content;
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 14,
        child: TextField(
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
          readOnly: !droit.write,
          controller: _controller,
          textAlignVertical: TextAlignVertical.center,
          onChanged: onchanged,
          maxLines: null,
          minLines: null,
          expands: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

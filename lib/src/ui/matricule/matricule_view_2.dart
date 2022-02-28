import 'package:flutter/material.dart';
import 'package:newgps/src/models/matricule.dart';
import 'package:newgps/src/models/user_droits.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/ui/login/login_as/save_account_provider.dart';
import 'package:newgps/src/ui/navigation/top_app_bar.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:newgps/src/widgets/inputs/search_widget.dart';
import 'package:provider/provider.dart';

import 'matricule_provider.dart';

class MatriculeView extends StatelessWidget {
  const MatriculeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatriculeProvider>(
      create: (_) => MatriculeProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: MatriculeDataView(),
    );
  }
}

class MatriculeDataView extends StatelessWidget {
  MatriculeDataView({Key? key}) : super(key: key);

  final List<String> _items = [
    'N',
    'WW',
    'Marque',
    'Couleur',
    'Matricule',
    'Nom chauffeur',
    'Téléphone 1',
    'Téléphone 2',
    'Kilométrage',
    'Réservoir en litre',
    'Enregistrement'
  ];

  @override
  Widget build(BuildContext context) {
    MatriculeProvider matriculeProvider =
        Provider.of<MatriculeProvider>(context);
    List<MatriculeModel> matricules = matriculeProvider.matricules;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool _isPortrait = mediaQuery.orientation == Orientation.portrait;
    return ChangeNotifierProvider<MatriculeProvider>(
        create: (_) => MatriculeProvider(),
        builder: (context, snapshot) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: const CustomAppBar(actions: [
              ]),
              body: InteractiveViewer(
                child: SingleChildScrollView(
                  scrollDirection: _isPortrait ? Axis.horizontal : Axis.vertical,
                  child: SizedBox(
                    height: mediaQuery.size.height,
                    child: SafeArea(
                      right: false,
                      bottom: false,
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BuildHead(
                              mediaQuery: mediaQuery,
                              matriculeProvider: matriculeProvider,
                              isPortrait: _isPortrait),
                          Container(
                            width: _isPortrait
                                ? mediaQuery.size.height
                                : mediaQuery.size.width * 0.94,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.grey),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color:
                                            AppConsts.mainColor.withOpacity(0.2)),
                                    children: _items.map<Widget>((item) {
                                      return SizedBox(
                                        height: 14,
                                        child: Center(
                                          child: Text(
                                            item,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    }).toList()),
                                ...matricules.map<TableRow>((matricule) {
                                  MatriculeProvider provider =
                                      Provider.of<MatriculeProvider>(context,
                                          listen: false);
/*                               var droit = Provider.of<SavedAcountProvider>(
                                          context,
                                          listen: false)
                                      .userDroits
                                      .droits[6]; */
                                  return TableRow(children: [
                                    BuildTextCell('${matricule.index}'),
                                    EditableCell(
                                      content: matricule.vehicleId,
                                      onchanged: (_) => matricule.vehicleId = _,
                                    ),
                                    EditableCell(
                                      content: matricule.vehicleModel,
                                      onchanged: (_) =>
                                          matricule.vehicleModel = _,
                                    ),

                                    EditableCell(
                                      content: matricule.vehicleColor,
                                      onchanged: (_) =>
                                          matricule.vehicleColor = _,
                                    ),
                                    //BuildTextCell(matricule.description),
                                    EditableCell(
                                      content: matricule.description,
                                      onchanged: (_) => matricule.description = _,
                                    ),
                                    EditableCell(
                                      content: matricule.driverName,
                                      onchanged: (_) => matricule.driverName = _,
                                    ),
                                    EditableCell(
                                      content: matricule.phone1,
                                      onchanged: (_) => matricule.phone1 = _,
                                    ),
                                    EditableCell(
                                      content: matricule.phone2,
                                      onchanged: (_) => matricule.phone2 = _,
                                    ),
                                    EditableCell(
                                      content: '${matricule.lastOdometerKM}',
                                      onchanged: (_) => matricule.lastOdometerKM =
                                          double.parse(_),
                                    ),
                                    EditableCell(
                                      content: '${matricule.fuelCapacity}',
                                      onchanged: (_) =>
                                          matricule.fuelCapacity = int.parse(_),
                                    ),
                                    //if (droit.write)
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: MainButton(
                                        onPressed: () async => await provider
                                            .onSave(matricule, context),
                                        height: 12,
                                        label: 'Enregister',
                                        fontSize: 8,
                                        backgroundColor: Colors.green,
                                        width: 88,
                                      ),
                                    ),
                                  ]);
                                }).toList()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}

class _BuildHead extends StatelessWidget {
  const _BuildHead({
    Key? key,
    required this.mediaQuery,
    required this.matriculeProvider,
    required bool isPortrait,
  })  : _isPortrait = isPortrait,
        super(key: key);

  final MediaQueryData mediaQuery;
  final MatriculeProvider matriculeProvider;
  final bool _isPortrait;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          _isPortrait ? mediaQuery.size.height : mediaQuery.size.width * 0.94,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchWidget(
            hint: 'Entrer matricule',
            onChnaged: matriculeProvider.search,
          ),
          const LogoutButton(),
        ],
      ),
    );
  }
}

class EditableCell extends StatefulWidget {
  final String content;
  final void Function(String val) onchanged;
  const EditableCell({Key? key, required this.content, required this.onchanged})
      : super(key: key);

  @override
  State<EditableCell> createState() => _EditableCellState();
}

class _EditableCellState extends State<EditableCell> {
  final TextEditingController _controller = TextEditingController();

  late Droit droit;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
    droit = Provider.of<SavedAcountProvider>(context, listen: false)
        .userDroits
        .droits[6];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: TextField(
        textInputAction: TextInputAction.done,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
        readOnly: !droit.write,
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onchanged,
        maxLines: null,
        minLines: null,
        expands: true,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class BuildTextCell extends StatelessWidget {
  final String content;
  final Color color;

  const BuildTextCell(this.content, {Key? key, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

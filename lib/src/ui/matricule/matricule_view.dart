import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'matricule_provider.dart';
import '../navigation/top_app_bar.dart';
import 'package:provider/provider.dart';

import '../../models/matricule.dart';
import '../../models/user_droits.dart';
import '../../utils/styles.dart';
import '../../widgets/buttons/main_button.dart';
import '../login/login_as/save_account_provider.dart';

class MatriculeViewTest extends StatelessWidget {
  const MatriculeViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MatriculeProvider>(
      create: (_) => MatriculeProvider(),
      builder: (BuildContext context, Widget? child) {
        return const MatriculeDataView();
      },
    );
  }
}

class MatriculeDataView extends StatelessWidget {
  const MatriculeDataView({Key? key}) : super(key: key);

  final List<String> _items = const [
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
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      extendBody: true,
      body: LazyDataTable(
        rows: matricules.length,
        columns: _items.length,
        tableTheme: const LazyDataTableTheme(
          columnHeaderColor: AppConsts.mainColor,
        ),
        tableDimensions: const LazyDataTableDimensions(
          cellHeight: 30,
          topHeaderHeight: 14,
        ),
        topHeaderBuilder: (int index) {
          return Center(
            child: Text(
              _items.elementAt(index),
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
            ),
          );
        },
        //leftHeaderBuilder: (i) => Center(child: Text("Row: ${i + 1}")),
        dataCellBuilder: (int i, int j) {
          if (i > 0 && i % 59 == 0) {
            matriculeProvider.fetchMatricules(fromListner: true, init: true);
          }

          MatriculeModel m = matricules.elementAt(i);
          switch (j) {
            case 0:
              return Center(child: Text('${m.index}'));
            case 1:
              return _BuildCell(
                content: m.vehicleId,
                onchanged: (_) => m.vehicleId = _,
              );
            case 2:
              return _BuildCell(
                content: m.vehicleModel,
                onchanged: (_) => m.vehicleModel = _,
              );
            case 3:
              return _BuildCell(
                content: m.vehicleColor,
                onchanged: (_) => m.vehicleColor = _,
              );
            case 4:
              return _BuildCell(
                content: m.description,
                onchanged: (_) => m.description = _,
              );
            case 5:
              return _BuildCell(
                content: m.driverName,
                onchanged: (_) => m.driverName = _,
              );
            case 6:
              return _BuildCell(
                content: m.phone1,
                onchanged: (_) => m.phone1 = _,
              );
            case 7:
              return _BuildCell(
                content: m.phone2,
                onchanged: (_) => m.phone2 = _,
              );

            case 8:
              return _BuildCell(
                content: m.fuelCapacity.toString(),
                onchanged: (_) => m.fuelCapacity = int.parse(_),
              );

            case 9:
              return MainButton(
                onPressed: () async =>
                    await matriculeProvider.onSave(m, context),
                height: 12,
                label: 'Enregister',
                fontSize: 8,
                backgroundColor: Colors.green,
                width: 88,
              );

            default:
              return const SizedBox();
          }
        },

        //topLeftCornerWidget: const Center(child: Text("Corner")),
      ),
    );
  }
}

class _EditableCell extends StatefulWidget {
  final String content;
  final void Function(String val) onchanged;
  const _EditableCell(
      {Key? key, required this.content, required this.onchanged})
      : super(key: key);

  @override
  State<_EditableCell> createState() => __EditableCellState();
}

class __EditableCellState extends State<_EditableCell> {
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}

class _BuildCell extends StatefulWidget {
  final String content;
  final void Function(String val) onchanged;
  const _BuildCell({Key? key, required this.content, required this.onchanged})
      : super(key: key);

  @override
  State<_BuildCell> createState() => _BuildCellState();
}

class _BuildCellState extends State<_BuildCell> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _editing = true;
        setState(() {});
      },
      child: _editing
          ? _BuildCell(content: widget.content, onchanged: widget.onchanged)
          : Text(widget.content),
    );
  }
}

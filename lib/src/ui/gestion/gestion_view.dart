import 'package:flutter/material.dart';
import '../../utils/styles.dart';
import 'gestion_provider.dart';
import '../navigation/top_app_bar.dart';
import '../../widgets/buttons/log_out_button.dart';
import 'package:provider/provider.dart';

class GestionView extends StatelessWidget {
  const GestionView({Key? key}) : super(key: key);

  final List<GestionModel> _items = const [
    GestionModel(
      label: 'Location',
      icon: Icons.emoji_transportation_rounded,
      color: Colors.greenAccent,
      index: 0,
    ),
    GestionModel(
      label: 'Transport',
      icon: Icons.directions_bus,
      color: Colors.purpleAccent,
      index: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return ChangeNotifierProvider<GestionProvider>(
        create: (_) => GestionProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: AppConsts.outsidePadding),
                  child: LogoutButton(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: SafeArea(
                    right: false,
                    bottom: false,
                    top: false,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: _items.length,
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      childAspectRatio: isPortrait ? 1.0 : 2.0,
                      ),
                      itemBuilder: (_, int index) {
                        return _BuildGestionCard(
                          item: _items.elementAt(index),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _BuildGestionCard extends StatelessWidget {
  final GestionModel item;
  const _BuildGestionCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GestionProvider provider = Provider.of<GestionProvider>(context);

    bool isSelected = item.index == provider.selectedIndex;
    return GestureDetector(
      onTap: () => provider.selectedIndex = item.index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: isSelected
                ? AppConsts.mainColor.withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppConsts.mainColor, width: 1.8),
            boxShadow: isSelected
                ? []
                : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                    ),
                  ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 66,
              color: AppConsts.mainColor,
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GestionModel {
  final String label;
  final IconData icon;
  final Color color;
  final int index;
  const GestionModel(
      {required this.label,
      required this.icon,
      required this.color,
      required this.index});
}

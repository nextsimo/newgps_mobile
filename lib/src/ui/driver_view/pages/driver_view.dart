import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/top_app_bar.dart';
import '../providers/driver_view_provider.dart';
import 'add_driver_view.dart';

class DriverView extends StatelessWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DriverViewProvider>(
        create: (_) => DriverViewProvider(),
        builder: (context, __) {
          return Scaffold(
            appBar: const CustomAppBar(),
            body: Column(
              children: const [
                AddDriverView(),
                _BuildDriversList(),
              ],
            ),
          );
        });
  }
}

class _BuildDriversList extends StatelessWidget {
  const _BuildDriversList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        bottom: false,
        top: false,
        right: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemCount: 10,
          itemBuilder: (_, int index) => const _BuildDriverCard(),
        ),
      ),
    );
  }
}

class _BuildDriverCard extends StatelessWidget {
  const _BuildDriverCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(145, 158, 158, 158),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Text('Driver Test'),
      ),
    );
  }
}



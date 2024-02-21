import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:provider/provider.dart';
import '../../navigation/top_app_bar.dart';
import '../providers/driver_view_provider.dart';

class DriverView extends StatelessWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ChangeNotifierProvider<DriverViewProvider>(
        create: (_) => DriverViewProvider(),
        builder: (context, __) {
          return  Scaffold(
            appBar: const CustomAppBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.drive_eta,
                    size: 50,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    'Bientôt disponible...',
                    style: textTheme.titleLarge,
                  ),

                ],
              ),
            ),
/*             body: Column(
              children: [
                _BuildHeader(),
                _BuildMyDrivers(),
              ],
            ), */
          );
        });
  }
}

class _BuildMyDrivers extends StatelessWidget {
  const _BuildMyDrivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.mainradius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/ibutton.webp',
                    width: 200.w,
                  ),
                  Container(
                    color: Colors.white70,
                  ),
                  const _BuildMyDriversList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildMyDriversList extends StatelessWidget {
  const _BuildMyDriversList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverViewProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.myDrivers.length,
      itemBuilder: (context, index) {
        final myDriver = provider.myDrivers[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConsts.mainradius),
            border: Border.all(
              color: AppConsts.mainColor,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConsts.mainradius),
                    color: Colors.blue),
                child: const Center(
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      myDriver.firstName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      myDriver.lastName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => provider.deleteDriver(myDriver.id),
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConsts.mainradius),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ListTile(
          onTap: context.read<DriverViewProvider>().refresh,
          title: const AutoSizeText(
            'Veuillez scanner votre IButton et actualiser',
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.refresh,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Divider(),
      ],
    );
  }
}

// ignore: unused_element
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
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
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

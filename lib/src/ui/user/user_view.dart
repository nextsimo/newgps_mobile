import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/styles.dart';
import '../navigation/top_app_bar.dart';
import 'user_drois_ui.dart';
import 'user_provider.dart';
import '../../widgets/buttons/log_out_button.dart';
import '../../widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';

import 'user_devices_ui.dart';

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: UserDataView(),
    );
  }
}

class UserDataView extends StatelessWidget {
  UserDataView({Key? key}) : super(key: key);

  final List<String> _items = [
    'Utilisateur',
    'Nom complet',
    'Téléphone',
    'Mot de passe',
    'Droits utilisateur',
    'Véhicules',
    'Enregistrement',
    'Supression',
  ];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<User> users = userProvider.users;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool _isPortrait = mediaQuery.orientation == Orientation.portrait;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const CustomAppBar(
        ),
        body: InteractiveViewer(
          child: SingleChildScrollView(
            scrollDirection: _isPortrait ? Axis.horizontal : Axis.vertical,
            child: SizedBox(
              width: _isPortrait
                  ? mediaQuery.size.height * 0.96
                  : mediaQuery.size.width,
              height: mediaQuery.size.height,
              child: SafeArea(
                right: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainButton(
                            width: 160,
                            onPressed: () async {
                              userProvider.addUserUi();
                            },
                            height: 35,
                            label: 'Ajuoter utilisateur',
                            backgroundColor: AppConsts.mainColor,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(right: AppConsts.outsidePadding),
                          child: LogoutButton(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: mediaQuery.orientation == Orientation.landscape
                          ? mediaQuery.size.width * 0.935
                          : mediaQuery.size.height,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                  color: AppConsts.mainColor.withOpacity(0.2)),
                              children: _items.map<Widget>((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    item,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList()),
                          ...users.map<TableRow>((user) {
                            return TableRow(children: [
                              EditableCell(
                                content: user.userId,
                                autofocus: user.userId.isEmpty,
                                onchanged: (_) => user.newUserId = _,
                              ),
                              EditableCell(
                                content: user.displayName,
                                onchanged: (_) => user.displayName = _,
                              ),
                              EditableCell(
                                content: user.contactPhone,
                                onchanged: (_) => user.contactPhone = _,
                              ),
                              EditableCell(
                                content: user.password,
                                onchanged: (_) => user.password = _,
                              ),
                              UserDroitsUi(
                                userDroits: userProvider.userDroits
                                    .elementAt(user.index),
                              ),
                              UserDevicesUi(
                                user: user,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: MainButton(
                                  onPressed: () async {
                                    await userProvider.onSave(
                                        user, context, user.index);
                                  },
                                  label: 'Enregistrer',
                                  backgroundColor: Colors.green,
                                  height: 25,
                                  fontSize: 8,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: MainButton(
                                  width: 70,
                                  onPressed: () async {
                                    // Supprimer
                                    await userProvider.deleteUser(user);
                                  },
                                  label: 'Supprimer',
                                  backgroundColor: Colors.red,
                                  height: 25,
                                  fontSize: 8,
                                ),
                              )
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
  }
}

class EditableCell extends StatefulWidget {
  final bool autofocus;
  final String content;
  final void Function(String val) onchanged;
  const EditableCell(
      {Key? key,
      required this.content,
      required this.onchanged,
      this.autofocus = false})
      : super(key: key);

  @override
  State<EditableCell> createState() => _EditableCellState();
}

class _EditableCellState extends State<EditableCell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void didUpdateWidget(covariant EditableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.autofocus,
      controller: _controller,
      onChanged: widget.onchanged,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      maxLines: 1,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
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
    return Center(
      child: Text(
        content,
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newgps/src/models/user_model.dart';
import 'package:newgps/src/ui/user/user_drois_ui.dart';
import 'package:newgps/src/ui/user/user_provider.dart';
import 'package:newgps/src/utils/styles.dart';
import 'package:newgps/src/widgets/buttons/log_out_button.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';
import 'package:provider/provider.dart';
import '../../widgets/my_loading_widget.dart';
import '../navigation/top_app_bar.dart';
import 'user_devices_ui.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      builder: (BuildContext context, Widget? child) {
        return child ?? const SizedBox();
      },
      child: const UserDataView(),
    );
  }
}

class UserDataView extends StatelessWidget {
  const UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<User> users = userProvider.users;
    return Scaffold(
      appBar: const CustomAppBar(
        actions: [],
      ),
      body: userProvider.loading
          ? const MyLoadingWidget()
          : _body(context, userProvider, users),
    );
  }

  Widget _body(
      BuildContext context, UserProvider userProvider, List<User> users) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return InteractiveViewer(
      minScale: 0.1,
      maxScale: 4.0,
      boundaryMargin: const EdgeInsets.symmetric(horizontal: 50),
      constrained: false,
      child: SizedBox(
        width: isPortrait
            ? MediaQuery.of(context).size.height * 0.96
            : MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainButton(
                  width: 200,
                  onPressed: () async {
                    userProvider.addUserUi();
                  },
                  height: 30,
                  label: 'Ajuoter utilisateur',
                  backgroundColor: AppConsts.mainColor,
                ),
                const LogoutButton(),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  const _BuildHeader(),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RowContent(
                          user: users[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader();

  @override
  Widget build(BuildContext context) {
    var borderSide =
        const BorderSide(color: Colors.black, width: AppConsts.borderWidth);
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border(bottom: borderSide, top: borderSide),
      ),
      child: const Row(
        children: [
          _BuildDivider(),
          _BuildTextCell('Utilisateur'),
          _BuildDivider(),
          _BuildTextCell('Nom'),
          _BuildDivider(),
          _BuildTextCell('Téléphone'),
          _BuildDivider(),
          _BuildTextCell('Mot de passe'),
          _BuildDivider(),
          _BuildTextCell('Droits'),
          _BuildDivider(),
          _BuildTextCell('Véhicules'),
          _BuildDivider(),
          _BuildTextCell('Actions'),
          _BuildDivider(),
        ],
      ),
    );
  }
}

class _BuildTextCell extends StatelessWidget {
  final String content;

  const _BuildTextCell(this.content);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text(
          content,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RowContent extends StatelessWidget {
  const RowContent({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 40.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: AppConsts.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          const _BuildDivider(),
          _EditableCell(
            content: user.userId,
            onchanged: (_) => user.newUserId = _,
          ),
          const _BuildDivider(),
          _EditableCell(
            content: user.displayName,
            onchanged: (_) => user.displayName = _,
          ),
          const _BuildDivider(),
          _EditableCell(
            content: user.contactPhone,
            onchanged: (_) => user.contactPhone = _,
          ),
          const _BuildDivider(),
          EditableCellPassword(
            content: user.password,
            onchanged: (_) => user.password = _,
          ),
          const _BuildDivider(),
          UserDroitsUi(
            userDroits: userProvider.userDroits.elementAt(user.index),
            flex: 1,
          ),
          const _BuildDivider(),
          UserDevicesUi(
            user: user,
            flex: 1,
          ),
          const _BuildDivider(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        userProvider.confirmSaveUser(context, user, user.index);
                      },
                      icon: const Icon(Icons.save),
                      color: Colors.green,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        userProvider.confirmDeleteUser(context, user);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const _BuildDivider(),
        ],
      ),
    );
  }
}

class _BuildDivider extends StatelessWidget {
  const _BuildDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConsts.borderWidth,
      color: AppConsts.mainColor,
      height: 40.h,
    );
  }
}

// editable cell password
class EditableCellPassword extends StatefulWidget {
  final String content;
  final int flex;
  final void Function(String val) onchanged;
  const EditableCellPassword(
      {super.key, required this.content, required this.onchanged, this.flex = 1});

  @override
  State<EditableCellPassword> createState() => _EditableCellPasswordState();
}

class _EditableCellPasswordState extends State<EditableCellPassword> {
  final TextEditingController _controller = TextEditingController();
  bool _isObscure = true;

  Widget _buildObscureButton() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.content;
    return Expanded(
      flex: widget.flex,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onchanged,
              onTap: () => {
                _controller.selection = TextSelection(
                    baseOffset: 0, extentOffset: _controller.text.length)
              },
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                // add obscure button
              ),
              obscureText: _isObscure,
            ),
          ),
          _buildObscureButton(),
        ],
      ),
    );
  }
}

class _EditableCell extends StatelessWidget {
  final String content;
  final void Function(String val) onchanged;
  _EditableCell(
      {required this.content, required this.onchanged});

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _controller.text = content;
    return Expanded(
      flex: 1,
      child: TextField(
        controller: _controller,
        onChanged: onchanged,
        onTap: () => {
          _controller.selection = TextSelection(
              baseOffset: 0, extentOffset: _controller.text.length)
        },
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

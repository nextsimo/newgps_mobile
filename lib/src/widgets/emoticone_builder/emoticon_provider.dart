import 'package:flutter/material.dart';
import 'package:newgps/src/widgets/buttons/main_button.dart';

class EmoticonProvider with ChangeNotifier {
  void showEmotsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return const Dialog(
            child: _BuildListEmoticon(),
          );
        });
  }
}

class _BuildListEmoticon extends StatelessWidget {
  const _BuildListEmoticon({
    Key? key,
  }) : super(key: key);

  final List<String> _emotics = const ['n-r', 'n-r', 'n-r', 'n-r'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: _emotics.map<Widget>((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icons/$e.png', height: 20,width: 20),
                      const SizedBox(width: 7),
                      Text('Emoticon $e'),
                    ],
                  ),
                  Radio(
                    value: true,
                    groupValue: 'test',
                    onChanged: (_) {},
                  )
                ],
              )).toList(),
          ),
          const SizedBox(height: 10),
          MainButton(
            onPressed: () {},
            label: 'Enregister',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class SearchWidget extends StatelessWidget {
  final bool autoFocus;
  final double? width;
  final double height;
  final void Function(String str)? onChnaged;
  final String? hint;
  const SearchWidget(
      {Key? key, this.onChnaged, this.hint, this.autoFocus = false, this.width, this.height =30.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConsts.mainradius),
        borderSide: const BorderSide(
            width: AppConsts.borderWidth, color: AppConsts.mainColor));
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(AppConsts.outsidePadding),
      child: SizedBox(
        width: width ?? size.width *0.36,
        height: height,
        child: TextField(
          textInputAction: TextInputAction.done,
          autofocus: autoFocus,
          onChanged: onChnaged,
/*           expands: true,
          maxLines: null,
          minLines: null, */
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(
              Icons.search,
              color: AppConsts.mainColor,
              size: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
          ),
        ),
      ),
    );
  }
}

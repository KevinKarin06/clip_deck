import 'package:clip_deck/domain/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClipboardHistoryHeader extends StatelessWidget {
  const ClipboardHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85 * 0.47,
          child: TextFormField(
            cursorHeight: 18.0,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'search'.tr(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 8.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: (value) {
              Provider.of<HomeProvider>(
                context,
                listen: false,
              ).updateSearchQuery(value);
            },
          ),
        ),
        SizedBox(width: 8.0),
        OutlinedButton(
          onPressed: () {
            Provider.of<HomeProvider>(context, listen: false).clearAll();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('delete_all'.tr()),
        ),
      ],
    );
  }
}

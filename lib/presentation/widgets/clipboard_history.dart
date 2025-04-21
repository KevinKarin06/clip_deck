import 'package:clip_deck/domain/home.dart';
import 'package:clip_deck/services/clipboard_service.dart';
import 'package:clip_deck/services/keyboard_simulator.dart';
import 'package:clip_deck/services/window_service.dart';
import 'package:clip_deck/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ClipboardHistory extends StatelessWidget {
  final List<String> items;

  const ClipboardHistory({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Text(
              items[index],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              await GetIt.I<WindowService>().hide();
              await GetIt.I<ClipboardService>().copyToClipboard(items[index]);
              await GetIt.I<KeyboardSimulatorService>().simulatePaste();
            },
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      try {
                        await GetIt.I<ClipboardService>().copyToClipboard(
                          items[index],
                        );
                        showToast('item_copied'.tr());
                      } catch (e) {
                        showToast(
                          'item_not_copied'.tr(),
                          type: ToastificationType.error,
                        );
                      }
                    },
                    icon: Icon(LucideIcons.copy),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).remove(items[index]);
                    },
                    icon: Icon(LucideIcons.trash),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

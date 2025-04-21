// ignore_for_file: use_build_context_synchronously

import 'package:clip_deck/domain/settings.dart';
import 'package:clip_deck/services/hotkey_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:provider/provider.dart';

class HotkeyInputModal extends StatefulWidget {
  const HotkeyInputModal({super.key});

  @override
  State<HotkeyInputModal> createState() => _HotkeyInputModalState();
}

class _HotkeyInputModalState extends State<HotkeyInputModal> {
  HotKey? _hotKey;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double modalHeight = size.height / 3;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(16),
        height: modalHeight,
        width: size.width / 1.8,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_hotKey == null) ...[
                    Text('press_combination_to_record').tr(),
                    SizedBox(height: 2),
                    Text(
                      'e.g. Ctrl + Alt + V',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                  HotKeyRecorder(
                    onHotKeyRecorded:
                        (HotKey hotkey) => {
                          setState(() {
                            _hotKey = hotkey;
                          }),
                        },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: modalHeight * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel').tr(),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed:
                        _hotKey != null
                            ? () async {
                              await GetIt.I<HotkeyService>().updateHotkey(
                                _hotKey!,
                              );
                              Provider.of<SettingsProvider>(
                                context,
                                listen: false,
                              ).notify();
                              Navigator.of(context).pop();
                            }
                            : null,
                    child: Text('save').tr(),
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

import 'dart:async';

import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/services/window_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotkeyService {
  final WindowService windowService;
  final DatabaseService _databaseService;

  HotkeyService(this.windowService, this._databaseService);

  Future<void> initialize() async {
    await hotKeyManager.unregisterAll();

    late dynamic hotKeyJson;
    hotKeyJson = _databaseService.box.get(Constants.hotkeyKey);
    hotKeyJson ??= Constants.defaultHotKey.toJson();

    HotKey hotKey = HotKey.fromJson(Map<String, dynamic>.from(hotKeyJson));
    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) async {
        await windowService.show(alwaysOnTop: true);
      },
    );
  }

  Future<void> updateHotkey(HotKey hotKey) async {
    await hotKeyManager.unregisterAll();

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) async {
        await windowService.show(alwaysOnTop: true);
      },
    );

    _databaseService.box.put(Constants.hotkeyKey, hotKey.toJson());
  }
}

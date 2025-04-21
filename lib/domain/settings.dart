import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  SettingsProvider(this._databaseService);

  Future<void> toggleTheme() async {
    final newTheme =
        getTheme() == Brightness.light ? Brightness.dark : Brightness.light;

    await setTheme(newTheme);
  }

  Brightness? getTheme() {
    final theme = _databaseService.box.get(Constants.themeKey);
    if (theme != null) {
      return theme == 'Brightness.light' ? Brightness.light : Brightness.dark;
    }
    return null;
  }

  bool getLaunchAtStart() {
    return _databaseService.box.get(
      Constants.launchAtStartKey,
      defaultValue: true,
    );
  }

  int getMaxHistoryItems() {
    return _databaseService.box.get(
      Constants.maxHistoryItemsKey,
      defaultValue: 10,
    );
  }

  HotKey getHotkey() {
    final hotKeyJson = _databaseService.box.get(
      Constants.hotkeyKey,
      defaultValue: Constants.defaultHotKey.toJson(),
    );

    return HotKey.fromJson(Map<String, dynamic>.from(hotKeyJson));
  }

  Future<void> setTheme(Brightness theme) async {
    await _databaseService.box.put(Constants.themeKey, theme.toString());
    notifyListeners();
  }

  Future<void> setLaunchAtStart(bool value) async {
    await _databaseService.box.put(Constants.launchAtStartKey, value);
    notifyListeners();
  }

  Future<void> setMaxHistoryItems(int count) async {
    await _databaseService.box.put(Constants.maxHistoryItemsKey, count);
    notifyListeners();
  }

  Future<void> setHotkey(Map<String, dynamic> hotkey) async {
    await _databaseService.box.put(Constants.hotkeyKey, hotkey);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}

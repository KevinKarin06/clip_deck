import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class Constants {
  static const String appName = 'Clip Deck';
  static const int maxHistoryItems = 50;
  static const String packageName = 'dev.clip-deck.app';
  static const List<Locale> supportedLocales = [Locale('en'), Locale('fr')];
  static const String translationPath = 'assets/translations';
  static const Locale fallbackLocale = Locale('en');
  static HotKey defaultHotKey = HotKey(
    key: PhysicalKeyboardKey.keyV,
    modifiers: [HotKeyModifier.control, HotKeyModifier.alt],
    scope: HotKeyScope.system,
  );
  static const String themeKey = 'theme';
  static const String localeKey = 'locale';
  static const String launchAtStartKey = 'launch_at_start';
  static const String maxHistoryItemsKey = 'max_history_items';
  static const String hotkeyKey = 'hotkey';
}

import 'package:clip_deck/app.dart';
import 'package:clip_deck/domain/settings.dart';
import 'package:clip_deck/services/clipboard_service.dart';
import 'package:clip_deck/services/hotkey_service.dart';
import 'package:clip_deck/services/keyboard_simulator.dart';
import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/services/startup_service.dart';
import 'package:clip_deck/services/tray_service.dart';
import 'package:clip_deck/services/window_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupServiceLocator();

  await GetIt.I<DatabaseService>().initialize();
  await GetIt.I<WindowService>().initialize();
  await GetIt.I<TrayService>().initialize();
  await GetIt.I<HotkeyService>().initialize();
  await GetIt.I<StartupService>().initialize();

  runApp(
    EasyLocalization(
      fallbackLocale: Constants.fallbackLocale,
      supportedLocales: Constants.supportedLocales,
      path: Constants.translationPath,
      child: ClipDeckApp(),
    ),
  );
}

void setupServiceLocator() {
  final windowService = WindowService();
  final databaseService = DatabaseService();

  GetIt.I.registerSingleton<DatabaseService>(databaseService);
  GetIt.I.registerSingleton<WindowService>(windowService);
  GetIt.I.registerSingleton<TrayService>(TrayService());
  GetIt.I.registerSingleton<HotkeyService>(
    HotkeyService(windowService, databaseService),
  );
  GetIt.I.registerSingleton<StartupService>(StartupService(databaseService));
  GetIt.I.registerSingleton<ClipboardService>(ClipboardService());
  GetIt.I.registerSingleton<KeyboardSimulatorService>(
    KeyboardSimulatorService(),
  );
  GetIt.I.registerSingleton<SettingsProvider>(
    SettingsProvider(databaseService),
  );
}

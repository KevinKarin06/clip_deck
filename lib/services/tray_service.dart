// ignore_for_file: implementation_imports

import 'dart:async';
import 'package:clip_deck/utils/constants.dart';
import 'package:clip_deck/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:easy_localization/src/easy_localization_controller.dart';
import 'package:easy_localization/src/localization.dart';

class TrayService {
  Future<void> initialize() async {
    await trayManager.setIcon(getTrayIconPath());

    await EasyLocalizationController.initEasyLocation();
    final controller = EasyLocalizationController(
      saveLocale: true,
      fallbackLocale: Constants.fallbackLocale,
      supportedLocales: Constants.supportedLocales,
      assetLoader: const RootBundleAssetLoader(),
      useOnlyLangCode: false,
      useFallbackTranslations: true,
      path: Constants.translationPath,
      onLoadError: (FlutterError e) {},
    );
    await controller.loadTranslations();
    Localization.load(
      controller.locale,
      translations: controller.translations,
      fallbackTranslations: controller.fallbackTranslations,
    );
    final Localization L = Localization.instance;

    Menu menu = Menu(
      items: [
        MenuItem(key: 'show_window', label: L.tr('open')),
        MenuItem.separator(),
        MenuItem(key: 'quit', label: L.tr('quit')),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  void addListener(TrayListener listener) {
    trayManager.addListener(listener);
  }

  void removeListener(TrayListener listener) {
    trayManager.removeListener(listener);
  }
}

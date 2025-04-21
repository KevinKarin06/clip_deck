import 'dart:io';
import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

class StartupService {
  final DatabaseService _databaseService;

  StartupService(this._databaseService);
  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final launchAtStart = _databaseService.box.get(
      Constants.launchAtStartKey,
      defaultValue: true,
    );

    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      packageName: Constants.packageName,
    );
    if (launchAtStart) {
      await enable();
    } else {
      await disable();
    }
  }

  Future<void> enable() async {
    await launchAtStartup.enable();
    await _databaseService.box.put(Constants.launchAtStartKey, true);
  }

  Future<void> disable() async {
    await launchAtStartup.disable();
    await _databaseService.box.put(Constants.launchAtStartKey, false);
  }

  Future<void> toggle(bool value) async {
    if (value) {
      await enable();
    } else {
      await disable();
    }
  }

  Future<bool> isEnabled() async {
    return await launchAtStartup.isEnabled();
  }
}

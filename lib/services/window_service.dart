import 'package:clip_deck/utils/constants.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  Future<void> initialize() async {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);

    WindowOptions windowOptions = WindowOptions(title: Constants.appName);
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  void addListener(WindowListener listener) {
    windowManager.addListener(listener);
  }

  void removeListener(WindowListener listener) {
    windowManager.removeListener(listener);
  }

  Future<void> show({alwaysOnTop = false}) async {
    await windowManager.setAlwaysOnTop(alwaysOnTop);
    await windowManager.center(animate: true);
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> hide() async {
    await windowManager.hide();
  }

  Future<void> destroy() async {
    await windowManager.destroy();
  }

  Future<void> handleCloseEvent() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      await windowManager.hide();
    }
  }

  Future<void> setPageTitle(String text) async {
    await windowManager.setTitle('${Constants.appName} - $text');
  }
}

import 'package:clip_deck/domain/home.dart';
import 'package:clip_deck/domain/settings.dart';
import 'package:clip_deck/presentation/layout.dart';
import 'package:clip_deck/presentation/theme.dart' show MaterialTheme;
import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/services/tray_service.dart';
import 'package:clip_deck/services/window_service.dart';
import 'package:clip_deck/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class ClipDeckApp extends StatefulWidget {
  const ClipDeckApp({super.key});

  @override
  State<ClipDeckApp> createState() => _ClipDeckAppState();
}

class _ClipDeckAppState extends State<ClipDeckApp>
    with WindowListener, TrayListener {
  @override
  void initState() {
    GetIt.I<TrayService>().addListener(this);
    super.initState();
    GetIt.I<WindowService>().addListener(this);
  }

  @override
  void dispose() {
    GetIt.I<TrayService>().removeListener(this);
    GetIt.I<WindowService>().removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    await GetIt.I<WindowService>().handleCloseEvent();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      await GetIt.I<WindowService>().show(alwaysOnTop: true);
    } else if (menuItem.key == 'quit') {
      GetIt.I<TrayService>().removeListener(this);
      GetIt.I<WindowService>().removeListener(this);
      GetIt.I<WindowService>().destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(GetIt.I<DatabaseService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(GetIt.I<DatabaseService>()),
        ),
      ],
      builder: (context, _) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        late Brightness? brightness = settingsProvider.getTheme();
        brightness ??= View.of(context).platformDispatcher.platformBrightness;
        TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
        MaterialTheme theme = MaterialTheme(textTheme);
        return ToastificationWrapper(
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Clip Deck',
            debugShowCheckedModeBanner: false,
            theme:
                brightness == Brightness.light ? theme.light() : theme.dark(),
            home: Scaffold(body: SafeArea(child: Layout())),
          ),
        );
      },
    );
  }
}

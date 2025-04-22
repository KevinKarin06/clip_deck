import 'package:clip_deck/domain/home.dart';
import 'package:clip_deck/domain/settings.dart';
import 'package:clip_deck/presentation/widgets/clipboard_history.dart';
import 'package:clip_deck/presentation/widgets/clipboard_history_header.dart';
import 'package:clip_deck/services/clipboard_service.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ClipboardListener {
  @override
  void initState() {
    GetIt.I<ClipboardService>().startWatching(this);
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I<ClipboardService>().stopWatching(this);
    super.dispose();
  }

  @override
  void onClipboardChanged() async {
    ClipboardData? clipboardData = await Clipboard.getData(
      Clipboard.kTextPlain,
    );
    if (clipboardData != null && clipboardData.text!.isNotEmpty) {
      Provider.of<HomeProvider>(
        context,
        listen: false,
      ).insert(clipboardData.text!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageWith = MediaQuery.of(context).size.width * 0.85;
    return Consumer2<SettingsProvider, HomeProvider>(
      builder: (context, _, homeProvider, _) {
        return Container(
          width: pageWith,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              ClipboardHistoryHeader(),
              SizedBox(height: 16.0),
              Expanded(child: ClipboardHistory(items: homeProvider.getItems)),
            ],
          ),
        );
      },
    );
  }
}

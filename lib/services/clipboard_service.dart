import 'dart:async';

import 'package:flutter/services.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';

class ClipboardService {
  void startWatching(ClipboardListener listener) {
    clipboardWatcher.addListener(listener);
    clipboardWatcher.start();
  }

  void stopWatching(ClipboardListener listener) {
    clipboardWatcher.removeListener(listener);
    clipboardWatcher.stop();
  }

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

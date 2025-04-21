import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keypress_simulator/keypress_simulator.dart';

class KeyboardSimulatorService {
  final MethodChannel _channel = MethodChannel(
    'com.clip_deck.keyboard_simulator',
  );
  Future<void> simulatePaste() async {
    if (Platform.isLinux) {
      await _channel.invokeMethod('simulateKeyboardPaste');
    } else {
      await keyPressSimulator.simulateKeyDown(PhysicalKeyboardKey.keyV, [
        ModifierKey.controlModifier,
      ]);
      await keyPressSimulator.simulateKeyUp(PhysicalKeyboardKey.keyV, [
        ModifierKey.controlModifier,
      ]);
    }
  }
}

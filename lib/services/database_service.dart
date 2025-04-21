import 'dart:async';
import 'package:hive_ce_flutter/hive_flutter.dart';

class DatabaseService {
  late final Box _box;
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('clip-deck');
  }

  Box get box => _box;
}

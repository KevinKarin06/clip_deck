import 'package:clip_deck/services/database_service.dart';
import 'package:clip_deck/utils/constants.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  final DatabaseService _databaseService;

  final List<String> _items;
  String _searchQuery = '';

  HomeProvider(this._databaseService) : _items = [];

  void insert(String item) {
    if (item.isEmpty) return;

    if (_items.contains(item)) {
      _items.remove(item);
    }

    _items.insert(0, item);

    if (_items.length >
        _databaseService.box.get(Constants.maxHistoryItemsKey)) {
      _items.removeLast();
    }

    notifyListeners();
  }

  void remove(String item) {
    if (_items.contains(item)) {
      _items.remove(item);
    }

    notifyListeners();
  }

  List<String> get items => List.unmodifiable(_items);

  List<String> get getItems {
    if (_searchQuery.isEmpty) return List.unmodifiable(_items);
    return _items
        .where(
          (item) => item.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];
  static const String _storageKey = 'favorites';
  late SharedPreferences _prefs;

  FavoritesProvider() {
    _loadFavorites();
  }

  List<Map<String, dynamic>> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    final String? storedFavorites = _prefs.getString(_storageKey);

    if (storedFavorites != null) {
      final List<dynamic> decoded = json.decode(storedFavorites);
      _favorites.addAll(decoded.cast<Map<String, dynamic>>());
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    await _prefs.setString(_storageKey, json.encode(_favorites));
  }

  bool isFavorite(Map<String, dynamic> spot) {
    return _favorites.any((favorite) => favorite['name'] == spot['name']);
  }

  void toggleFavorite(Map<String, dynamic> spot) {
    if (isFavorite(spot)) {
      _favorites.removeWhere((favorite) => favorite['name'] == spot['name']);
    } else {
      _favorites.add(spot);
    }
    _saveFavorites();
    notifyListeners();
  }
}

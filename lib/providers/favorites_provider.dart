import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tourist_spot.dart';
import '../services/tourist_spots_service.dart';

class FavoritesProvider with ChangeNotifier {
  final List<TouristSpot> _favorites = [];
  static const String _storageKey = 'favorites';
  late SharedPreferences _prefs;
  final _touristSpotsService = TouristSpotsService();

  FavoritesProvider() {
    _loadFavorites();
  }

  List<TouristSpot> get favorites => _favorites;

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    final String? storedFavorites = _prefs.getString(_storageKey);

    if (storedFavorites != null) {
      final List<dynamic> decoded = json.decode(storedFavorites);
      _favorites.addAll(
        decoded.map((item) => TouristSpot.fromJson(item)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    await _prefs.setString(
      _storageKey,
      json.encode(_favorites.map((spot) => spot.toJson()).toList()),
    );
  }

  bool isFavorite(String id) {
    return _favorites.any((spot) => spot.id == id);
  }

  Future<void> toggleFavorite(String id, {TouristSpot? spot}) async {
    try {
      if (isFavorite(id)) {
        _favorites.removeWhere((favorite) => favorite.id == id);
      } else {
        if (spot != null) {
          _favorites.add(spot);
        } else {
          final spotDetails = await _touristSpotsService.getTouristSpotById(id);
          final newSpot = TouristSpot.fromJson(spotDetails);
          _favorites.add(newSpot);
        }
      }
      await _saveFavorites();
      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar favoritos: $e');
    }
  }
}

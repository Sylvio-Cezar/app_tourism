import 'package:flutter/foundation.dart';
import '../models/tourist_spot.dart';
import '../services/tourist_spots_service.dart';
import '../database/database_helper.dart';

class FavoritesProvider with ChangeNotifier {
  final List<TouristSpot> _favorites = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _touristSpotsService = TouristSpotsService();
  bool _isLoading = true;

  FavoritesProvider() {
    _loadFavorites();
  }

  List<TouristSpot> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> _loadFavorites() async {
    try {
      final spots = await _databaseHelper.getAllFavorites();
      _favorites.clear();
      _favorites.addAll(spots);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar favoritos: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    return await _databaseHelper.isFavorite(id);
  }

  Future<void> toggleFavorite(String id, {TouristSpot? spot}) async {
    try {
      final isFav = await isFavorite(id);

      if (isFav) {
        await _databaseHelper.deleteFavorite(id);
        _favorites.removeWhere((favorite) => favorite.id == id);
      } else {
        final TouristSpot spotToAdd;
        if (spot != null) {
          spotToAdd = spot;
        } else {
          final spotDetails = await _touristSpotsService.getTouristSpotById(id);
          spotToAdd = TouristSpot.fromJson(spotDetails);
        }

        await _databaseHelper.insertFavorite(spotToAdd);
        _favorites.add(spotToAdd);
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar favoritos: $e');
    }
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }

  Future<void> updateFavorite(TouristSpot spot) async {
    try {
      await _databaseHelper.updateFavorite(spot);
      final index = _favorites.indexWhere((f) => f.id == spot.id);
      if (index != -1) {
        _favorites[index] = spot;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar favorito: $e');
    }
  }

  Future<TouristSpot?> getFavoriteById(String id) async {
    try {
      return await _databaseHelper.getFavoriteById(id);
    } catch (e) {
      print('Erro ao buscar favorito: $e');
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_urls.dart';
import '../../home/models/apartment_model.dart';

class FavoritesProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  
  List<Apartment> _favorites = [];
  bool _isLoading = false;

  List<Apartment> get favorites => _favorites;
  bool get isLoading => _isLoading;

  // ---------------------------------------------------------------------------
  // FETCH FAVORITES
  // ---------------------------------------------------------------------------
  Future<void> fetchFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.get(AppUrls.favorites);
      
      List<dynamic> data;
      if (response is Map && response.containsKey('data')) {
        data = response['data'];
      } else if (response is List) {
        data = response;
      } else {
        data = [];
      }

      // Map the response to Apartment objects
      // Note: Backend might return the apartment object nested inside the favorite record
      _favorites = data.map((item) {
        // Check if the item itself is the apartment or if it has an 'apartment' key
        if (item['apartment'] != null) {
          return Apartment.fromJson(item['apartment']);
        }
        return Apartment.fromJson(item);
      }).toList();

    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // TOGGLE FAVORITE (Add/Remove)
  // ---------------------------------------------------------------------------
  Future<void> toggleFavorite(int apartmentId) async {
    // Optimistic Update: Check if already in list
    final isFav = _favorites.any((apt) => apt.id == apartmentId);

    try {
      if (isFav) {
        // Remove
        await _apiClient.delete('${AppUrls.favorites}/$apartmentId');
        _favorites.removeWhere((apt) => apt.id == apartmentId);
      } else {
        // Add
        await _apiClient.post(AppUrls.favorites, {'apartment_id': apartmentId});
        // We re-fetch to get the full apartment details correctly
        await fetchFavorites();
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Helper to check status for UI
  bool isFavorite(int apartmentId) {
    return _favorites.any((apt) => apt.id == apartmentId);
  }
}
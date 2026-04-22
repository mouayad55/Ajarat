import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_urls.dart';
import '../models/apartment_model.dart';

class ApartmentProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Apartment> _apartments = [];
  List<Apartment> _filteredApartments = [];
  
  bool _isLoading = false;

  // Getters
  List<Apartment> get apartments => _filteredApartments;
  bool get isLoading => _isLoading;

  // ---------------------------------------------------------------------------
  // FETCH ALL APARTMENTS
  // ---------------------------------------------------------------------------
  Future<void> fetchApartments() async {
    _isLoading = true;
    notifyListeners();

    try {
      // The API response is expected to be a List or { "data": [...] }
      final response = await _apiClient.get(AppUrls.apartments);
      
      List<dynamic> data;
      // Handle Laravel pagination wrapper if exists, or direct list
      if (response is Map && response.containsKey('data')) {
        data = response['data'];
      } else if (response is List) {
        data = response;
      } else {
        data = [];
      }

      _apartments = data.map((item) => Apartment.fromJson(item)).toList();
      _filteredApartments = List.from(_apartments); // Initially, filter = all
      
    } catch (e) {
      print("Error fetching apartments: $e");
      // We don't throw here to avoid crashing UI, just show empty list
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH / FILTER LOGIC
  // ---------------------------------------------------------------------------
  void search(String query) {
    if (query.isEmpty) {
      _filteredApartments = List.from(_apartments);
    } else {
      _filteredApartments = _apartments.where((apt) {
        return apt.city.toLowerCase().contains(query.toLowerCase()) ||
               apt.governorate.toLowerCase().contains(query.toLowerCase()) ||
               apt.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterByCity(String? city) {
    if (city == null || city.isEmpty) {
      _filteredApartments = List.from(_apartments);
    } else {
      _filteredApartments = _apartments.where((apt) {
        return apt.city.toLowerCase() == city.toLowerCase();
      }).toList();
    }
    notifyListeners();
  }
}
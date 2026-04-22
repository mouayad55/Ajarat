import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/app_urls.dart';
import '../models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  
  bool _isLoading = false;
  List<Booking> _myBookings = [];

  bool get isLoading => _isLoading;
  List<Booking> get myBookings => _myBookings;

  // ---------------------------------------------------------------------------
  // CREATE BOOKING
  // ---------------------------------------------------------------------------
  Future<void> createBooking({
    required int apartmentId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final start = startDate.toIso8601String().split('T')[0];
      final end = endDate.toIso8601String().split('T')[0];

      await _apiClient.post(AppUrls.bookings, {
        'apartment_id': apartmentId,
        'start_date': start,
        'end_date': end,
      });
      
      // Refresh list after booking
      await fetchMyBookings(); 

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH MY BOOKINGS
  // ---------------------------------------------------------------------------
  Future<void> fetchMyBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.get(AppUrls.myBookings);
      
      List<dynamic> data;
      if (response is Map && response.containsKey('data')) {
        data = response['data'];
      } else if (response is List) {
        data = response;
      } else {
        data = [];
      }

      _myBookings = data.map((item) => Booking.fromJson(item)).toList();

    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // CANCEL BOOKING
  // ---------------------------------------------------------------------------
  Future<void> cancelBooking(int bookingId) async {
    try {
      // Assuming backend uses PATCH or PUT to cancel
      await _apiClient.post('${AppUrls.bookings}/$bookingId/cancel', {
        '_method': 'PATCH' // Laravel trick if using POST for PATCH
      });
      
      // Update local list instantly
      final index = _myBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        // We manually create a new object with updated status to save a network call
        // Or just re-fetch:
        await fetchMyBookings();
      }
    } catch (e) {
      rethrow;
    }
  }
}
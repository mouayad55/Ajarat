import '../../home/models/apartment_model.dart';

class Booking {
  final int id;
  final String startDate;
  final String endDate;
  final String status; // 'active', 'cancelled', 'finished'
  final Apartment? apartment; // The apartment booked

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.apartment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      // Handle case where apartment data might be nested or missing
      apartment: json['apartment'] != null 
          ? Apartment.fromJson(json['apartment']) 
          : null,
    );
  }
}
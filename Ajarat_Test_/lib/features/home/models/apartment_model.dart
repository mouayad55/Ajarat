import '../../../core/constants/app_urls.dart';

class Apartment {
  final int id;
  final String description;
  final String governorate;
  final String city;
  final double price;
  final String? photoPath;
  final bool isAvailable;
  // Owner ID might be null based on your migration, handling just in case
  final int? ownerId; 

  Apartment({
    required this.id,
    required this.description,
    required this.governorate,
    required this.city,
    required this.price,
    this.photoPath,
    required this.isAvailable,
    this.ownerId,
  });

  // Factory to create an object from JSON
  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'],
      description: json['description'] ?? '',
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      // Ensure price is treated as a double even if int in DB
      price: (json['price'] as num).toDouble(), 
      photoPath: json['photo_path'],
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
      ownerId: json['owner_id'],
    );
  }

  // Helper to get full Image URL
  String get imageUrl {
    if (photoPath != null) {
      // If the path already contains http, return it, else append storageUrl
      if (photoPath!.startsWith('http')) return photoPath!;
      return '${AppUrls.storageUrl}/$photoPath'; 
    }
    // Return a placeholder if no image exists
    return 'https://via.placeholder.com/400x300.png?text=No+Image';
  }
}
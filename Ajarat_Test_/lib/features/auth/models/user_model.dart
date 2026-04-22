import '../../../core/constants/app_urls.dart';

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? personalPhotoPath;
  final String role; // 'user' or 'owner'

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.personalPhotoPath,
    required this.role,
  });

  String get fullName => '$firstName $lastName';

  // Helper to get full Image URL
  String get imageUrl {
    if (personalPhotoPath != null) {
      if (personalPhotoPath!.startsWith('http')) return personalPhotoPath!;
      return '${AppUrls.storageUrl}/$personalPhotoPath';
    }
    return ''; // Return empty to show default icon
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      personalPhotoPath: json['personal_photo_path'],
      role: json['role'] ?? 'user',
    );
  }

  // To save to Shared Preferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'personal_photo_path': personalPhotoPath,
      'role': role,
    };
  }
}
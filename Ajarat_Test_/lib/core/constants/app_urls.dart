class AppUrls {
  // ---------------------------------------------------------------------------
  // BASE URL CONFIGURATION
  // ---------------------------------------------------------------------------
  // Use '10.0.2.2' if using the Android Emulator.
  // Use '127.0.0.1' if using the iOS Simulator.
  // Use your PC's IP address (e.g., 192.168.1.5) if using a Real Phone.
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Base URL for viewing images (Laravel storage)
  static const String storageUrl = 'http://10.0.2.2:8000/storage';

  // ---------------------------------------------------------------------------
  // AUTH ROUTES
  // ---------------------------------------------------------------------------
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout = '$baseUrl/logout';
  static const String user = '$baseUrl/user';

  // ---------------------------------------------------------------------------
  // APARTMENT ROUTES
  // ---------------------------------------------------------------------------
  static const String apartments = '$baseUrl/apartments';
  
  // ---------------------------------------------------------------------------
  // BOOKING ROUTES
  // ---------------------------------------------------------------------------
  static const String bookings = '$baseUrl/bookings';
  static const String myBookings = '$baseUrl/my-bookings';

  // ---------------------------------------------------------------------------
  // FEATURES ROUTES
  // ---------------------------------------------------------------------------
  static const String favorites = '$baseUrl/favorites';
  static const String ratings = '$baseUrl/ratings';
}
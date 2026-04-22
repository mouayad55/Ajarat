[README.md](https://github.com/user-attachments/files/26973301/README.md)
# 🏠 Ajarat – Residential Apartment Booking App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Laravel-11.x-red?logo=laravel)](https://laravel.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> A full-stack mobile application for browsing and booking residential apartments,
> built with **Flutter** (Frontend) and **Laravel** (Backend API).

---

## 📖 Description

**Ajarat** is a residential housing booking application that provides a complete
digital experience for both **Apartment Owners** and **Tenants**.

Users can register, browse available apartments, view detailed listings, make
bookings, manage reservations, and save favorites — all from a clean and modern
mobile interface.

---

## ✨ Features

### 🔐 Authentication
- User Registration with Phone Number
- Personal Photo & ID Card Upload
- Login & Logout with Sanctum Token
- Auto-Login (Saved Token)
- Role Selection (Tenant / Owner)
- Admin Approval System (Pending Status)

### 🏘️ Apartments
- Browse All Available Apartments
- Search by City, Governorate, or Description
- Filter by City
- View Full Apartment Details
- Photo Display with Caching

### 📅 Booking System
- Conflict-Free Date Selection (Start & End Date)
- Submit Booking Requests
- View Booking History (Active / Finished / Cancelled)
- Cancel Active Bookings

### ❤️ Favorites
- Add / Remove Apartments from Favorites
- View Favorites List
- Quick Book from Favorites

### 👤 Profile
- View Real User Name & Photo
- Theme Toggle (Light / Dark Mode)
- Language Toggle (English / Arabic with RTL Support)
- Logout

### 💬 Messaging (UI)
- Chat List Interface between Tenant and Owner
- *(Backend integration pending)*

---

## 🛠️ Tech Stack

| Layer             | Technology                          |
|-------------------|-------------------------------------|
| Frontend          | Flutter (Dart)                      |
| Backend           | Laravel 11 (PHP)                    |
| Authentication    | Laravel Sanctum (Bearer Token)      |
| State Management  | Provider                            |
| Local Storage     | Shared Preferences                  |
| HTTP Client       | http (Dart)                         |
| Image Handling    | image_picker + cached_network_image |
| Database          | SQLite (Dev) / MySQL (Production)   |

---

## 🗂️ Project Structure
lib/
├── core/
│   ├── api/
│   │   └── api_client.dart          # HTTP Engine (GET, POST, Multipart)
│   ├── constants/
│   │   ├── app_colors.dart          # Color Palette
│   │   └── app_urls.dart            # API Endpoints
│   ├── providers/
│   │   └── settings_provider.dart   # Theme & Language Logic
│   └── theme/
│       └── app_theme.dart           # Light & Dark Theme
│
├── features/
│   ├── auth/
│   │   ├── models/user_model.dart
│   │   ├── providers/auth_provider.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── home/
│   │   ├── models/apartment_model.dart
│   │   ├── providers/apartment_provider.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   └── filter_screen.dart
│   │   └── widgets/apartment_card.dart
│   ├── apartment/
│   │   └── screens/apartment_details_screen.dart
│   ├── booking/
│   │   ├── models/booking_model.dart
│   │   ├── providers/booking_provider.dart
│   │   └── screens/
│   │       ├── booking_screen.dart
│   │       └── my_bookings_screen.dart
│   ├── favorites/
│   │   ├── providers/favorites_provider.dart
│   │   └── screens/favorites_screen.dart
│   ├── profile/
│   │   └── screens/profile_screen.dart
│   └── messages/
│       └── screens/chat_list_screen.dart
│
└── shared/
    └── widgets/
        ├── custom_button.dart
        └── custom_textfield.dart
`

---

## ⚙️ Backend API Endpoints

| Method | Endpoint                      | Description            | Auth |
|--------|-------------------------------|------------------------|------|
| POST   | /api/register               | Register new user      | ❌   |
| POST   | /api/login                  | Login with phone       | ❌   |
| POST   | /api/logout                 | Logout                 | ✅   |
| GET    | /api/user                   | Get current user       | ✅   |
| GET    | /api/apartments             | List all apartments    | ✅   |
| POST   | /api/apartments             | Add new apartment      | ✅   |
| GET    | /api/apartments/{id}        | View apartment details | ✅   |
| PUT    | /api/apartments/{id}        | Update apartment       | ✅   |
| DELETE | /api/apartments/{id}        | Delete apartment       | ✅   |
| POST   | /api/bookings               | Create booking         | ✅   |
| GET    | /api/my-bookings            | View my bookings       | ✅   |
| PUT    | /api/bookings/{id}          | Modify booking         | ✅   |
| PATCH  | /api/bookings/{id}/cancel   | Cancel booking         | ✅   |
| GET    | /api/favorites              | View favorites         | ✅   |
| POST   | /api/favorites              | Add to favorites       | ✅   |
| DELETE | /api/favorites/{id}         | Remove from favorites  | ✅   |
| POST   | /api/ratings/{booking}      | Rate a booking         | ✅   |

---

## 🚀 Getting Started

### Prerequisites

- PHP >= 8.2
- Composer
- Flutter SDK >= 3.x
- SQLite or MySQL

---

### 🔧 Backend Setup (Laravel)

# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/ajarat.git

# 2. Navigate to backend folder
cd ajarat-backend

# 3. Install dependencies
composer install

# 4. Copy environment file
cp .env.example .env

# 5. Generate application key
php artisan key:generate

# 6. Run database migrations
php artisan migrate

# 7. Link storage for photos
php artisan storage:link

# 8. Start the server
php artisan serve --host=YOUR_LOCAL_IP --port=8000

[4/21/2026 8:30 PM] 𝑴𝒐𝒖𝒂𝒚𝒂𝒅 𝑨𝒍‑𝑴𝒘𝒂𝒏𝒆𝒔: | Method | Endpoint                      | Description            | Auth |
|--------|-------------------------------|------------------------|------|
| POST   | /api/register               | Register new user      | ❌   |
| POST   | /api/login                  | Login with phone       | ❌   |
| POST   | /api/logout                 | Logout                 | ✅   |
| GET    | /api/user                   | Get current user       | ✅   |
| GET    | /api/apartments             | List all apartments    | ✅   |
| POST   | /api/apartments             | Add new apartment      | ✅   |
| GET    | /api/apartments/{id}        | View apartment details | ✅   |
| PUT    | /api/apartments/{id}        | Update apartment       | ✅   |
| DELETE | /api/apartments/{id}        | Delete apartment       | ✅   |
| POST   | /api/bookings               | Create booking         | ✅   |
| GET    | /api/my-bookings            | View my bookings       | ✅   |
| PUT    | /api/bookings/{id}          | Modify booking         | ✅   |
| PATCH  | /api/bookings/{id}/cancel   | Cancel booking         | ✅   |
| GET    | /api/favorites              | View favorites         | ✅   |
| POST   | /api/favorites              | Add to favorites       | ✅   |
| DELETE | /api/favorites/{id}         | Remove from favorites  | ✅   |
| POST   | /api/ratings/{booking}      | Rate a booking         | ✅   |

---

## 🚀 Getting Started

### Prerequisites

- PHP >= 8.2
- Composer
- Flutter SDK >= 3.x
- SQLite or MySQL

---

### 🔧 Backend Setup (Laravel)

# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/ajarat.git

# 2. Navigate to backend folder
cd ajarat-backend

# 3. Install dependencies
composer install

# 4. Copy environment file
cp .env.example .env

# 5. Generate application key
php artisan key:generate

# 6. Run database migrations
php artisan migrate

# 7. Link storage for photos
php artisan storage:link

# 8. Start the server
php artisan serve --host=YOUR_LOCAL_IP --port=8000
---

### 📱 Frontend Setup (Flutter)

# 1. Navigate to Flutter project
cd ajarat-flutter

# 2. Install dependencies
flutter pub get

# 3. Update the IP Address in:
# lib/core/constants/app_urls.dart
# Change baseUrl to match your Laravel server IP

# 4. Run the app
flutter run -d windows   # Windows Desktop
flutter run -d android   # Android Phone
---

## 🔧 Configuration

Open lib/core/constants/app_urls.dart and update the IP to match your server:

// Change this to your Laravel server IP address
static const String baseUrl    = 'http://YOUR_IP:8000/api';
static const String storageUrl = 'http://YOUR_IP:8000/storage';
| Device Type       | IP to Use                          |
|-------------------|------------------------------------|
| Android Emulator  | 10.0.2.2                         |
| Windows Desktop   | 127.0.0.1                        |
| Physical Phone    | Your PC's Wi-Fi IP (e.g 192.168.1.5) |

---

## 🗃️ Database Schema

| Table                   | Description                                              |
|-------------------------|----------------------------------------------------------|
| users                 | User accounts (Tenants & Owners) with status & role      |
| apartments            | Apartment listings with location and price               |
| bookings              | Reservations with start/end dates and status             |
| ratings               | Apartment ratings submitted by tenants                   |
| favorites             | Saved apartments per user                                |
| personal_access_tokens| Sanctum authentication tokens                           |

---

## 📋 Requirements Coverage

| Requirement                    | Status        |
|--------------------------------|---------------|
[4/21/2026 8:30 PM] 𝑴𝒐𝒖𝒂𝒚𝒂𝒅 𝑨𝒍‑𝑴𝒘𝒂𝒏𝒆𝒔: | User Registration (Phone)      | ✅ Done       |
| Personal Info + Photos         | ✅ Done       |
| Login & Logout                 | ✅ Done       |
| Browse & View Apartments       | ✅ Done       |
| Apartment Filtering            | ✅ Done       |
| Conflict-Free Booking          | ✅ Done       |
| Booking Modification / Cancel  | ✅ Done       |
| Booking History                | ✅ Done       |
| Apartment Rating               | ✅ Done       |
| Notification System            | ⚠️ UI Only   |
| Language Support (Ar/En + RTL) | ✅ Done       |
| In-App Messaging               | ⚠️ UI Only   |
| Theme Mode (Dark / Light)      | ✅ Done       |
| Favorites List                 | ✅ Done       |
| Admin Web Interface            | ✅ Laravel    |

---

## ⚠️ Known Limitations

- Messaging: Chat UI is built, but the backend API for real-time
  messaging is not yet implemented.
- Notifications: The notification UI exists but requires Firebase
  or Laravel Echo for a real implementation.
- Admin Panel: The approval system exists in the database schema
  (status: pending/approved/rejected), but the admin web interface
  needs further development.

---

## 🎓 Academic Information

> Final Project – Programming Languages Course – 2025/2026

| Detail   | Info                          |
|----------|-------------------------------|
| Course   | Programming Languages         |
| Year     | 2025 – 2026                   |
| Type     | Group Project (4–5 Students)  |

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

This is an academic project.
Contributions are welcome after the submission deadline.

---

*Built with ❤️ using Flutter & Laravel*

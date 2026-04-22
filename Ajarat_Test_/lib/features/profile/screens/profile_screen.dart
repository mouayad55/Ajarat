import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart'; // <--- Import Settings
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access User Data
    final user = Provider.of<AuthProvider>(context).currentUser;
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Profile Picture (Real)
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: (user?.imageUrl.isNotEmpty ?? false)
                    ? CachedNetworkImageProvider(user!.imageUrl)
                    : null,
                child: (user?.imageUrl.isEmpty ?? true)
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            
            // 2. Real Name
            Text(
              user?.fullName ?? 'Guest User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.phone ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // 3. Settings Section (Working Switches)
            _buildSectionTitle('Settings'),
            
            // Theme Switch
            SwitchListTile(
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (val) {
                settings.toggleTheme(val);
              },
            ),

            // Language Switch
            SwitchListTile(
              title: const Text('Arabic Language (RTL)'),
              subtitle: const Text('اللغة العربية'),
              secondary: const Icon(Icons.language),
              value: settings.locale.languageCode == 'ar',
              onChanged: (val) {
                settings.toggleLanguage(val);
              },
            ),
            
            const Divider(height: 40),

            // Logout Button
            CustomButton(
              text: 'Logout',
              color: Colors.red,
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
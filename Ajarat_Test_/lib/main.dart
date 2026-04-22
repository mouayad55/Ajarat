import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/settings_provider.dart'; // <--- Import Settings
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/favorites/providers/favorites_provider.dart';
import 'features/home/providers/apartment_provider.dart';
import 'features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async load
  final settings = SettingsProvider();
  await settings.loadSettings(); // Load theme/lang before app starts

  runApp(MyApp(settingsProvider: settings));
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;

  const MyApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsProvider), // 1. Settings
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ApartmentProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (ctx, settings, child) {
          return Consumer<AuthProvider>(
            builder: (ctx, auth, _) => MaterialApp(
              title: 'Ajarat Housing',
              debugShowCheckedModeBanner: false,
              
              // Dynamic Theme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settings.themeMode, // <--- Dynamic

              // Dynamic Language
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              locale: settings.locale, // <--- Dynamic

              home: FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (auth.token != null) {
                    return const HomeScreen();
                  } else {
                    return const LoginScreen();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/menu_service.dart';
import 'services/order_service.dart';
import 'services/table_service.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
        ChangeNotifierProvider(create: (_) => TableService()),
      ],
      child: MaterialApp(
        title: 'Restaurant Management System',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            primary: Colors.orange,
            secondary: Colors.orange.shade800,
            surface: Colors.white,
            background: const Color(0xFFfff8e1), // Very light orange
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,

          // AppBar tema - mevcut orange rengi korundu
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: false, // Restaurant Management System için sol hizalama
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),

          // Card tema - orange uyumlu
          cardTheme: CardTheme(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            shadowColor: Colors.orange.withOpacity(0.2),
          ),

          // Button tema - orange theme uyumlu
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),

          // Input decoration - orange accent
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.orange,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),

          // Bottom Navigation - orange theme
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.orange,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          // Floating Action Button
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 4,
          ),

          // Text tema - orange ile uyumlu dark colors
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d2d2d),
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2d2d2d),
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2d2d2d),
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF424242),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF424242),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF616161),
            ),
          ),
        ),

        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
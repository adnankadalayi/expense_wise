import 'package:expense_wise/all_transaction/screens/all_transaction.dart';
import 'package:expense_wise/bottom_navigation/screens/add_transaction.dart';
import 'package:expense_wise/bottom_navigation/screens/bottom_navigation_screen.dart';
import 'package:expense_wise/bottom_navigation/screens/home_screen.dart';
import 'package:expense_wise/bottom_navigation/screens/settings_screen.dart';
import 'package:expense_wise/core/app_theme.dart';
import 'package:expense_wise/settings/screens/edit_profile.dart';
import 'package:expense_wise/splash_screen/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ExpenseWise',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.system, // Switch between light and dark based on system
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/add', page: () => AddTransactionScreen()),
        GetPage(name: '/all', page: () => AllTransactionsScreen()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
        GetPage(name: '/edit-profile', page: () => EditProfilePage()),
      ],
    );
  }
}

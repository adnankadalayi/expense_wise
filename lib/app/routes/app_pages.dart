import 'package:get/get.dart';

import '../modules/home/screens/bottom_navigation_screen.dart';
import '../modules/home/screens/add_transaction.dart';
import '../modules/transactions/screens/all_transaction.dart';
import '../modules/settings/screens/edit_profile.dart';
import '../modules/splash/screens/splash_screen.dart';
import '../modules/accounts/views/accounts_view.dart';
import '../modules/accounts/views/add_account_view.dart';
import '../modules/accounts/bindings/accounts_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainScreen(),
      binding: AccountsBinding(),
    ),
    GetPage(name: _Paths.SPLASH, page: () => SplashScreen()),
    GetPage(name: _Paths.TRANSACTIONS, page: () => AllTransactionsScreen()),
    GetPage(name: _Paths.ADD_TRANSACTION, page: () => AddTransactionScreen()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => EditProfilePage()),
    GetPage(
      name: _Paths.ACCOUNTS,
      page: () => const AccountsView(),
      binding: AccountsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACCOUNT,
      page: () => AddAccountView(),
      binding: AccountsBinding(),
    ),
  ];
}

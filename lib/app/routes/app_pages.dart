import 'package:expense_wise/app/modules/home/bindings/home_binding.dart';
import 'package:get/get.dart';

import '../modules/home/screens/bottom_navigation_screen.dart';
import '../modules/home/screens/add_transaction.dart';
import '../modules/transactions/screens/all_transaction.dart';
import '../modules/settings/screens/edit_profile.dart';
import '../modules/splash/screens/splash_screen.dart';
import '../modules/accounts/views/accounts_view.dart';
import '../modules/accounts/views/add_account_view.dart';
import '../modules/accounts/bindings/accounts_binding.dart';
import '../modules/settings/views/category_management_view.dart';
import '../modules/recurring/views/recurring_transactions_view.dart';
import '../modules/recurring/views/add_recurring_transaction_view.dart';
import '../modules/recurring/bindings/recurring_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/fire/views/fire_view.dart';
import '../modules/fire/bindings/fire_binding.dart';
import '../modules/investments/views/investments_view.dart';
import '../modules/investments/views/add_investment_view.dart';
import '../modules/investments/bindings/investments_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/transfers/views/transfer_history_view.dart';
import '../modules/transfers/bindings/transfers_binding.dart';
import '../modules/security/screens/lock_screen.dart';
import '../modules/settings/views/security_settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainScreen(),
      binding: HomeBinding(),
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
    GetPage(
      name: _Paths.CATEGORY_MANAGEMENT,
      page: () => const CategoryManagementView(),
    ),
    GetPage(
      name: _Paths.RECURRING,
      page: () => const RecurringTransactionsView(),
      binding: RecurringBinding(),
    ),
    GetPage(
      name: _Paths.ADD_RECURRING,
      page: () => const AddRecurringTransactionView(),
    ),
    GetPage(
      name: _Paths.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.FIRE,
      page: () => const FireView(),
      binding: FireBinding(),
    ),
    GetPage(
      name: _Paths.INVESTMENTS,
      page: () => const InvestmentsView(),
      binding: InvestmentsBinding(),
    ),
    GetPage(name: _Paths.ADD_INVESTMENT, page: () => const AddInvestmentView()),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.TRANSFER_HISTORY,
      page: () => const TransferHistoryView(),
      binding: TransfersBinding(),
    ),
    GetPage(name: _Paths.LOCK_SCREEN, page: () => const LockScreen()),
    GetPage(
      name: _Paths.SECURITY_SETTINGS,
      page: () => const SecuritySettingsView(),
    ),
  ];
}

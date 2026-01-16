part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const TRANSACTIONS = _Paths.TRANSACTIONS;
  static const SETTINGS = _Paths.SETTINGS;
  static const SPLASH = _Paths.SPLASH;
  static const ADD_TRANSACTION = _Paths.ADD_TRANSACTION;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const ACCOUNTS = _Paths.ACCOUNTS;
  static const ADD_ACCOUNT = _Paths.ADD_ACCOUNT;
  static const CATEGORY_MANAGEMENT = _Paths.CATEGORY_MANAGEMENT;
  static const RECURRING = _Paths.RECURRING;
  static const ADD_RECURRING = _Paths.ADD_RECURRING;
  static const REPORTS = _Paths.REPORTS;
  static const FIRE = _Paths.FIRE;
  static const INVESTMENTS = _Paths.INVESTMENTS;
  static const ADD_INVESTMENT = _Paths.ADD_INVESTMENT;
  static const CALENDAR = _Paths.CALENDAR;
  static const TRANSFER_HISTORY = _Paths.TRANSFER_HISTORY;
  static const LOCK_SCREEN = _Paths.LOCK_SCREEN;
  static const SECURITY_SETTINGS = _Paths.SECURITY_SETTINGS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const TRANSACTIONS = '/transactions';
  static const SETTINGS = '/settings';
  static const SPLASH = '/splash';
  static const ADD_TRANSACTION = '/add-transaction';
  static const EDIT_PROFILE = '/edit-profile';
  static const ACCOUNTS = '/accounts';
  static const ADD_ACCOUNT = '/add-account';
  static const CATEGORY_MANAGEMENT = '/category-management';
  static const RECURRING = '/recurring';
  static const ADD_RECURRING = '/add-recurring';
  static const REPORTS = '/reports';
  static const FIRE = '/fire';
  static const INVESTMENTS = '/investments';
  static const ADD_INVESTMENT = '/add-investment';
  static const CALENDAR = '/calendar';
  static const TRANSFER_HISTORY = '/transfer-history';
  static const LOCK_SCREEN = '/lock-screen';
  static const SECURITY_SETTINGS = '/security-settings';
}

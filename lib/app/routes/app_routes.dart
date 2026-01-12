part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const TRANSACTIONS = _Paths.TRANSACTIONS;
  static const SETTINGS = _Paths.SETTINGS;
  static const SPLASH = _Paths.SPLASH;
  static const ADD_TRANSACTION = _Paths.ADD_TRANSACTION;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const TRANSACTIONS = '/transactions';
  static const SETTINGS = '/settings';
  static const SPLASH = '/splash';
  static const ADD_TRANSACTION = '/add-transaction';
  static const EDIT_PROFILE = '/edit-profile';
}

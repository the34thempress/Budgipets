import 'package:flutter/material.dart';
import 'screens/login_screens/login.dart';
import 'screens/login_screens/create_account.dart';
import 'screens/main_screens/profile_page.dart';
import 'screens/main_screens/dashboard.dart';
import 'screens/setting_screens/settings_page.dart';
import 'screens/main_screens/store.dart';
import 'screens/main_screens/pet_management.dart';
import 'screens/main_screens/allowance.dart';

class Routes {
  static const String login = '/login';
  static const String create = '/create';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String store = '/store';
  static const String pet_management = '/pet_management';
  static const String allowance = '/allowance';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    create: (context) => CreateAccountPage(),
    profile: (context) => ProfilePage(),
    dashboard: (context) => DashboardPage(),
    settings: (context) => SettingsPage(),
    store: (context) => StorePage(),
    pet_management: (context) => PetManagementPage(),
    allowance: (context) => LogEntryPage(),
  };
}

import 'package:flutter/material.dart';
import 'login.dart';
import 'create_account.dart';
import 'profile_page.dart';
import 'dashboard.dart';
import 'settings_page.dart';

class Routes {
  static const String login = '/login';
  static const String create = '/create';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    create: (context) => CreateAccountPage(),
    profile: (context) => ProfilePage(),
    dashboard: (context) => DashboardPage(),
    settings: (context) => SettingsPage(),
  };
}

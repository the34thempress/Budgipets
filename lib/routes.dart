import 'package:flutter/material.dart';
import 'pages/auth/login.dart';
import 'pages/auth/create_account.dart';
import 'pages/profile/profile_page.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/settings/settings_page.dart';
import 'pages/store/store.dart';
import 'pages/pet/pet_management.dart';
import 'pages/logs/allowance.dart';
import 'pages/logs/log_history.dart';
import 'pages/auth/forgot_password.dart';
import 'screens/tutorial_screens/tutorial.dart';

class Routes {
  static const String login = '/login';
  static const String create = '/create';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';
  static const String settings = '/settings';
  static const String store = '/store';
  static const String pet_management = '/pet_management';
  static const String allowance = '/allowance';
  static const String logs = '/logs';
  static const String forgot_password = '/forgot_password';
  static const String tutorial = '/tutorial'; 

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    create: (context) => CreateAccountPage(),
    profile: (context) => ProfilePage(),
    dashboard: (context) => DashboardPage(),
    settings: (context) => SettingsPage(),
    store: (context) => StorePage(),
    pet_management: (context) => PetManagementPage(),
    allowance: (context) => LogEntryPage(),
    logs: (context) => LogsPage(),
    forgot_password: (context) => ForgotPasswordPage(),
    tutorial: (context) => TutorialScreen(),
  };
}

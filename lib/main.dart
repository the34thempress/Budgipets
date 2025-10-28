import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:budgipets/controllers/audio_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AudioService().playMusic(); // start music immediately
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budgipets",
      initialRoute: Routes.login,  // start at login
      routes: Routes.routes,
    );
  }
}

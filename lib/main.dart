import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wbtygogbahfbwayydvfm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndidHlnb2diYWhmYndheXlkdmZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2MTQ5MTMsImV4cCI6MjA3NzE5MDkxM30.O9k_lKi_ByQBnwQE9F3D6P7vEKsqn0ULVCNYuBgLLeY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budgipets',
      initialRoute: Routes.login,
      routes: Routes.routes,
    );
  }
}

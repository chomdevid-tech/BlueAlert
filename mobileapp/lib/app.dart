import 'package:flutter/material.dart';

import 'data/alert_repository.dart';
import 'data/firebase_alert_service.dart';
import 'screens/main_screen.dart';

class BlueAlertApp extends StatelessWidget {
  const BlueAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAlertService firebaseAlertService = FirebaseAlertService();

    final AlertRepository alertRepository = AlertRepository(
      firebaseAlertService,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlueAlert',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: MainScreen(alertRepository: alertRepository),
    );
  }
}

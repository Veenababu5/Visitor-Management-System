import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/registration_provider.dart';
import '../providers/visit_provider.dart';
import '../providers/visitor_provider.dart';
import '../screens/visitor/welcome/welcome_screen.dart';
import 'theme/app_theme.dart';

class ITGVisitorApp extends StatelessWidget {
  const ITGVisitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
      ],
      child: MaterialApp(
        title: 'ITG Visitor Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/app/app_shell.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/features/auth/screens/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: SmartFactoryApp()));
}

class SmartFactoryApp extends StatefulWidget {
  const SmartFactoryApp({super.key});

  @override
  State<SmartFactoryApp> createState() => _SmartFactoryAppState();
}

class _SmartFactoryAppState extends State<SmartFactoryApp> {
  bool _signedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Factory Quality & Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _signedIn
          ? AppShell(
              onSignOut: () => setState(() => _signedIn = false),
            )
          : LoginPage(
              onSignedIn: () => setState(() => _signedIn = true),
            ),
    );
  }
}

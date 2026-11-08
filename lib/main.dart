import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/app/app_shell.dart';
import 'package:smart_factory_qc/app/sync_status.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/features/auth/login_page.dart';

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
  // Starts offline with 3 queued records so the banner is visible in the demo.
  final _sync = SyncStatus(offline: true, pendingRecords: 3);
  bool _signedIn = false;

  @override
  void dispose() {
    _sync.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Factory Quality & Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _signedIn
          ? AppShell(
              syncStatus: _sync,
              onSignOut: () => setState(() => _signedIn = false),
            )
          : LoginPage(onSignedIn: () => setState(() => _signedIn = true)),
    );
  }
}

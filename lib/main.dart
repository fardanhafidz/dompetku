import 'package:dompetku/core/env/env.dart';
import 'package:flutter/material.dart';
import 'routing/app_router.dart';
import 'shared/theme/app_theme.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseKey,
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.config,
    );
  }
}

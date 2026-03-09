import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/auth/presentation/pages/otp_verification_screen.dart';
import '../features/auth/presentation/pages/create_pin_screen.dart';
import '../features/auth/presentation/pages/biometric_setup_screen.dart';
import '../features/auth/presentation/pages/pin_login_screen.dart';
import '../features/home/presentation/pages/home_screen.dart';
import '../features/history/presentation/pages/history_screen.dart';
import '../features/insights/presentation/pages/insights_screen.dart';
import '../features/profile/presentation/pages/profile_screen.dart';
import 'main_wrapper.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorHistoryKey = GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
  static final _shellNavigatorInsightsKey = GlobalKey<NavigatorState>(debugLabel: 'shellInsights');
  static final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

  static final config = GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final email = state.extra as String?;
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/create-pin',
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: '/biometric-setup',
        builder: (context, state) => const BiometricSetupScreen(),
      ),
      GoRoute(
        path: '/pin-login',
        builder: (context, state) => const PinLoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHistoryKey,
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorInsightsKey,
            routes: [
              GoRoute(
                path: '/insights',
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

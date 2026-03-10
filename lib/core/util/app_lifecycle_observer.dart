import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_event.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({super.key, required this.child});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Trigger lock when app goes to background or becomes inactive (e.g. multitasking view)
      context.read<AuthBloc>().add(AppLockTriggered());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

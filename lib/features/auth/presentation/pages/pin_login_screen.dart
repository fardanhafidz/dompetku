import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_event.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_state.dart';

import '../../../../shared/theme/app_colors.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pin_dots_indicator.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  bool _isVerifying = false;
  String _pin = '';

  void _onDigitPressed(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 6) {
        setState(() {
          _isVerifying = true;
        });
        // Dispatch verification event
        context.read<AuthBloc>().add(AppLockVerificationRequested(_pin));
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Security Check',
          style: GoogleFonts.manrope(
            color: AppColors.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() {
              _pin = ''; // Reset PIN on failure
              _isVerifying = false;
            });
          } else if (state is AuthAuthenticated) {
            if (!state.isLocked) {
              // Success! isLocked is false, GoRouter will handle redirect
              setState(() {
                _isVerifying = false;
              });
            } else if (state.error != null) {
              // Error while still authenticated (incorrect PIN)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
              setState(() {
                _pin = ''; // Reset PIN on failure
                _isVerifying = false;
              });
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // Lock Icon inside a circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome back',
                        style: GoogleFonts.manrope(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please enter your PIN to unlock Dompetku',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: AppColors.subtext,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        height: 48,
                        child: Center(
                          child: _isVerifying
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 3,
                                  ),
                                )
                              : PinDotsIndicator(
                                  length: 6,
                                  currentPinLength: _pin.length,
                                ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.only(top: 24, bottom: 32),
                        child: AbsorbPointer(
                          absorbing: _isVerifying,
                          child: NumericKeypad(
                            onDigitPressed: _onDigitPressed,
                            onBackspacePressed: _onBackspacePressed,
                            leftIcon: Icons
                                .lock_outline, // Changed from face to lock for better context
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

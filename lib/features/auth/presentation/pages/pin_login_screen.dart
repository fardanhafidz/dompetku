import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompetku/features/auth/domain/repositories/auth_repositories.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_event.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_state.dart';
import 'package:dompetku/core/di/injection_container.dart';

import '../../../../shared/theme/app_colors.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pin_dots_indicator.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _pin = '';
  bool _useFingerprint = false;
  bool _isVerifying = false;

  void _onDigitPressed(String digit) {
    if (_useFingerprint) return;

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
    if (_useFingerprint) return;

    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _toggleLoginMethod() async {
    if (!_useFingerprint) {
      // Try biometric auth immediately when switching to fingerprint
      final authBloc = context.read<AuthBloc>();
      // authRepository is not directly exposed on AuthBloc, but we can use GetIt since it's registered.
      // Or we should have a use case for this.
      // Actually, AuthBloc should probably have a BiometricAuthRequested event that handles this.
      // But for now, I'll use sl<AuthRepository>().
      final authRepository = sl<AuthRepository>();
      final result = await authRepository.authenticateBiometric();

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (isSuccess) {
          if (isSuccess) {
            authBloc.add(AppLockBypassed());
          }
        },
      );
    }
    setState(() {
      _useFingerprint = !_useFingerprint;
      if (_useFingerprint) {
        _pin = ''; // Clear PIN when switching to fingerprint
      }
    });
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
          _useFingerprint ? '' : 'Security Check',
          style: GoogleFonts.manrope(
            color: AppColors.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: _useFingerprint
            ? null
            : IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: AppColors.onBackground),
                onPressed: () => context.pop(),
              ),
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
          } else if (state is AuthAuthenticated && !state.isLocked) {
            // Success! isLocked is false, GoRouter will handle redirect
            setState(() {
              _isVerifying = false;
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String fullName = 'User';
                  if (state is AuthAuthenticated) {
                    fullName = state.session.user.fullName.split(' ')[0];
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!_useFingerprint) ...[
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
                      ] else ...[
                        const SizedBox(height: 32),
                        // Fingerprint Icon UI (similar to biometric setup)
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary.withValues(alpha: 0.1),
                          ),
                          child: Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.secondary.withValues(alpha: 0.2),
                              ),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondary
                                        .withValues(alpha: 0.3),
                                  ),
                                  child: const Icon(
                                    Icons.fingerprint,
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Welcome back, $fullName',
                          style: GoogleFonts.manrope(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Use fingerprint to unlock',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.subtext,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Replace Spacer with a flexible gap for scroll view
                      const SizedBox(height: 32),

                      // Toggle Method Button
                      TextButton.icon(
                        onPressed: _toggleLoginMethod,
                        icon: Icon(
                          _useFingerprint ? Icons.pin : Icons.fingerprint,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        label: Text(
                          _useFingerprint
                              ? 'Use PIN instead'
                              : 'Use Fingerprint instead',
                          style: GoogleFonts.manrope(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      if (!_useFingerprint) ...[
                        const SizedBox(height: 16),
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
                                  .face, // Placeholder for FaceID/Biometrics icon if needed on keypad
                            ),
                          ),
                        ),
                      ],
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

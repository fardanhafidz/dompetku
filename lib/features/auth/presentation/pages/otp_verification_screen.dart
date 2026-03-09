import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_event.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_state.dart';
import 'package:dompetku/shared/theme/app_colors.dart';
import 'package:dompetku/core/constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../widgets/auth_primary_button.dart';
import '../widgets/otp_input_row.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;
  const OtpVerificationScreen({super.key, this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = AppConstants.otpCountdownDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = AppConstants.otpCountdownDuration;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = widget.email ?? 'email Anda';
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/create-pin');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Icon Lock
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Verifikasi Kode',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                'Masukkan 6 digit kode yang dikirim ke\n$displayEmail',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.subtext,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // OTP Input Row
              OtpInputRow(
                controller: _otpController,
                length: 6,
                onChanged: (val) {
                  if (val.length == 6) {
                    // Auto verify or handle
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
              
              const SizedBox(height: 48),
              
              // Verifikasi Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AuthPrimaryButton(
                    text: 'Verifikasi',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_otpController.text.length == 6) {
                        context.read<AuthBloc>().add(
                              VerifyOtpRequested(
                                email: widget.email ?? '',
                                token: _otpController.text,
                                type: OtpType.signup,
                              ),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Masukkan 6 digit kode penuh')),
                        );
                      }
                    },
                  );
                },
              ),
              
              const SizedBox(height: 48),
              
              // Resend Text
              Text(
                'Tidak menerima kode?',
                style: GoogleFonts.manrope(
                  color: AppColors.subtext,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _secondsRemaining == 0
                        ? () {
                            context
                                .read<AuthBloc>()
                                .add(SendOtpRequested(widget.email ?? ''));
                            _startTimer();
                          }
                        : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Kirim ulang',
                      style: GoogleFonts.manrope(
                        color: _secondsRemaining == 0
                            ? AppColors.primary
                            : AppColors.subtext.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${_formatTime(_secondsRemaining)})',
                    style: GoogleFonts.manrope(
                      color: AppColors.subtext.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

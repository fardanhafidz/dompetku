import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dompetku/features/auth/presentation/bloc/auth_event.dart';

import '../../../../shared/theme/app_colors.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pin_dots_indicator.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String _pin = '';

  void _onDigitPressed(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 6) {
        // Save PIN
        Future.delayed(const Duration(milliseconds: 300), () async {
          if (mounted) {
            final authBloc = context.read<AuthBloc>();
            // Since we don't have a specific event for saving PIN yet (we could add one),
            // I'll call the repository directly or add a new event.
            // Let's add SavePinRequested to AuthEvent.
            authBloc.add(SavePinRequested(_pin));
            // Let the router handle redirection once state updates
          }
        });
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
        automaticallyImplyLeading: false, // Mandatory setup, no back button
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                'Buat PIN Baru',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Masukkan 6 digit PIN untuk\nmengamankan akun Anda',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.subtext,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              PinDotsIndicator(
                length: 6,
                currentPinLength: _pin.length,
              ),
              const Spacer(),
              // Optional lock icon in the middle area
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: NumericKeypad(
                  onDigitPressed: _onDigitPressed,
                  onBackspacePressed: _onBackspacePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

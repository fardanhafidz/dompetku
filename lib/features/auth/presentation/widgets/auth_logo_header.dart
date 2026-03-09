import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dompetku/shared/theme/app_colors.dart';

class AuthLogoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;

  const AuthLogoHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLogo) ...[
          const SizedBox(height: 60),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Center(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.subtext,
            ),
          ),
        ),
      ],
    );
  }
}

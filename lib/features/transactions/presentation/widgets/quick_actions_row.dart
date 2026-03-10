import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';

class QuickActionItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class QuickActionsRow extends StatelessWidget {
  final List<QuickActionItem> actions;

  const QuickActionsRow({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actions.map((action) => _buildAction(action)).toList(),
      ),
    );
  }

  Widget _buildAction(QuickActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              action.icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.subtext,
            ),
          ),
        ],
      ),
    );
  }
}

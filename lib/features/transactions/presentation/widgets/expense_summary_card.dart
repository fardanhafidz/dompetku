import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';

class ExpenseSummaryCard extends StatelessWidget {
  final double totalExpenses;
  final double trendPercentage;
  final VoidCallback? onDetailPressed;

  const ExpenseSummaryCard({
    super.key,
    required this.totalExpenses,
    required this.trendPercentage,
    this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = trendPercentage >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.xxLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Pengeluaran',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalExpenses.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Trend Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isUp ? '+' : ''}${trendPercentage.toStringAsFixed(1)}% vs Bulan Lalu',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Detail Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDetailPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                ),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Lihat Detail',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';

class WeeklyChartCard extends StatelessWidget {
  final double weeklySpending;
  final double weeklyBudget;
  final List<double> weeklyData;

  const WeeklyChartCard({
    super.key,
    required this.weeklySpending,
    required this.weeklyBudget,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final budgetPercentage = weeklyBudget > 0
        ? ((weeklyBudget - weeklySpending) / weeklyBudget * 100).round()
        : 0;
    final isUnderBudget = weeklySpending <= weeklyBudget;
    final maxData = weeklyData.reduce((a, b) => a > b ? a : b);
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.xxLarge,
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Spending vs Budget',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.subtext,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${weeklySpending.toInt()}',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ \$${weeklyBudget.toInt()}',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: AppColors.subtext,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Under budget badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (isUnderBudget
                      ? AppColors.secondary
                      : const Color(0xFFE57373))
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUnderBudget ? Icons.trending_down : Icons.trending_up,
                  size: 14,
                  color: isUnderBudget
                      ? AppColors.primary
                      : const Color(0xFFE57373),
                ),
                const SizedBox(width: 4),
                Text(
                  '${budgetPercentage.abs()}% ${isUnderBudget ? 'under' : 'over'} budget',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isUnderBudget
                        ? AppColors.primary
                        : const Color(0xFFE57373),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Bar Chart
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final barHeight =
                    maxData > 0 ? (weeklyData[index] / maxData) * 100 : 0.0;
                final isFriday = index == 4; // Highlight Friday as "today"

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: 28,
                          decoration: BoxDecoration(
                            color: AppColors.neutralGrey,
                            borderRadius: AppRadius.medium,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 28,
                                height: barHeight.clamp(28, 100),
                                decoration: BoxDecoration(
                                  color: isFriday
                                      ? AppColors.accentGreen
                                      : AppColors.accentGreen.withValues(alpha: 0.35),
                                  borderRadius: AppRadius.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dayLabels[index],
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight:
                              isFriday ? FontWeight.w700 : FontWeight.w500,
                          color: isFriday
                              ? AppColors.onBackground
                              : AppColors.subtext,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

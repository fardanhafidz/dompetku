import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';
import '../../domain/entities/transaction_entity.dart';
import 'recent_transaction_tile.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final VoidCallback? onSeeAllPressed;

  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              GestureDetector(
                onTap: onSeeAllPressed,
                child: Text(
                  'See All',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.subtext,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...transactions.map(
          (tx) => RecentTransactionTile(transaction: tx),
        ),
      ],
    );
  }
}

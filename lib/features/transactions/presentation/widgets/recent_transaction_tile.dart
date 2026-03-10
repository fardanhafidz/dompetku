import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';
import '../../domain/entities/transaction_entity.dart';

class RecentTransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const RecentTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);

    String dateLabel;
    if (txDate == today) {
      dateLabel = 'Today';
    } else if (txDate == today.subtract(const Duration(days: 1))) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = DateFormat('MMM d').format(transaction.date);
    }

    final timeLabel = transaction.notes == 'Automatic'
        ? 'Automatic'
        : DateFormat('h:mm a').format(transaction.date);

    // Map category name to Material Icon
    IconData getCategoryIcon(String categoryName) {
      switch (categoryName.toLowerCase()) {
        case 'groceries':
          return Icons.shopping_cart_outlined;
        case 'transport':
          return Icons.directions_transit_filled_outlined;
        case 'entertainment':
          return Icons.movie_filter_outlined;
        case 'food & drink':
          return Icons.coffee_rounded;
        default:
          return Icons.receipt_long_outlined;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Category icon circle
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.neutralGrey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                getCategoryIcon(transaction.category.name),
                color: AppColors.accentGreen,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.category.name} • $dateLabel',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.subtext,
                  ),
                ),
              ],
            ),
          ),
          // Amount & time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-\$${transaction.amount.toStringAsFixed(2)}',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeLabel,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppColors.subtext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

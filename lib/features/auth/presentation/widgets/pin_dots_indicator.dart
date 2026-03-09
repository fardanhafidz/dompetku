import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';

class PinDotsIndicator extends StatelessWidget {
  final int length;
  final int currentPinLength;

  const PinDotsIndicator({
    super.key,
    this.length = 6,
    required this.currentPinLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        bool isFilled = index < currentPinLength;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

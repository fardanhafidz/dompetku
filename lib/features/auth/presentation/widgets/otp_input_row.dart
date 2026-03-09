import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';

class OtpInputRow extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const OtpInputRow({
    super.key,
    this.length = 6,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Invisible TextField handling the actual input
        Opacity(
          opacity: 0.01, // Slightly visible to ensure it receives focus/clicks
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: length,
            autofocus: true,
            onChanged: onChanged,
            cursorColor: Colors.transparent,
            style: const TextStyle(color: Colors.transparent),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        // Fake UI for display
        IgnorePointer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(length, (index) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  final text = value.text;
                  final isSelected = text.length == index;
                  final isFilled = index < text.length;
                  final digit = isFilled ? text[index] : '-';

                  return Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isFilled
                                  ? AppColors.primary
                                  : AppColors.secondary.withValues(alpha: 0.3)),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        digit,
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isFilled
                              ? AppColors.onBackground
                              : AppColors.subtext.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

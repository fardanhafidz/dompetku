import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/theme/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final IconData? leftIcon;
  final VoidCallback? onLeftIconPressed;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.leftIcon,
    this.onLeftIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionKey(
              icon: leftIcon,
              onPressed: onLeftIconPressed,
            ),
            _buildKey('0'),
            _buildActionKey(
              icon: Icons.backspace_rounded,
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String digit) {
    return Expanded(
      child: Center(
        child: InkWell(
          onTap: () => onDigitPressed(digit),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            child: Text(
              digit,
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({IconData? icon, VoidCallback? onPressed}) {
    return Expanded(
      child: Center(
        child: icon != null
            ? IconButton(
                onPressed: onPressed,
                iconSize: 32,
                color: AppColors.onBackground,
                icon: Icon(icon),
              )
            : const SizedBox(width: 72, height: 72),
      ),
    );
  }
}

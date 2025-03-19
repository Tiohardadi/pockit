import 'package:flutter/material.dart';
import 'package:pockit/presentation/constant/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final Color? backgroundColor; // Parameter opsional untuk warna background

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.borderRadius = 12,
    this.backgroundColor, // Tambahkan parameter opsional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary, // Gunakan warna yang diberikan, atau default ke AppColors.primary
          foregroundColor: AppColors.textLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

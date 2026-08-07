import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ITGLogo extends StatelessWidget {
  final double size;
  const ITGLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.navyPrimary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'ITG',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}

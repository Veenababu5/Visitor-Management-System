import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/buttons/secondary_button.dart';
import '../../../widgets/common/itg_logo.dart';
import '../registration/step1_personal_details.dart';
import '../home/visitor_home_screen.dart';
import '../pass/qr_pass_screen.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const ITGLogo(size: 34),
                      const SizedBox(width: 8),
                      const Text(
                        'ITG',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navyPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.language, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          'EN',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Building Illustration Box
              Container(
                width: 180,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.blueLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.corporate_fare,
                      size: 90,
                      color: AppColors.blueAccent,
                    ),
                    Positioned(
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.navyPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Title & Subtitle
              const Text(
                'Welcome to\nITG Visitor\nManagement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Secure • Simple • Contactless',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Action Buttons
              PrimaryButton(
                text: 'Register for a Visit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Step1PersonalDetailsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Check Appointment Status',
                onPressed: () {
                  final authProv =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (authProv.isAuthenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisitorHomeScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Scan QR Pass',
                icon: Icons.qr_code_scanner,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrPassScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Protected footer note
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14, color: AppColors.textLight),
                  SizedBox(width: 4),
                  Text(
                    'Your information is protected',
                    style: TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

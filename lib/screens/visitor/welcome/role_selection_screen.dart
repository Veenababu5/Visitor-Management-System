import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/common/itg_logo.dart';
import '../auth/user_registration_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _showRoleDialog(BuildContext context, String roleName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('$roleName Module'),
        content: Text('$roleName module will be added in the next project phase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.navyPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(child: ITGLogo(size: 60)),
              const SizedBox(height: 20),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ITG Visitor\nManagement System',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please select your role\nto continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),

              // ── Role 1: VISITOR ─────────────────────────────────────────
              _buildRoleCard(
                context,
                title: 'I am a',
                role: 'VISITOR',
                subtitle: 'Register as Visitor',
                icon: Icons.person_outline,
                color: AppColors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserRegistrationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // ── Role 2: EMPLOYEE ────────────────────────────────────────
              _buildRoleCard(
                context,
                title: 'I am an',
                role: 'EMPLOYEE',
                subtitle: 'Login as Employee',
                icon: Icons.badge_outlined,
                color: AppColors.approved,
                onTap: () => _showRoleDialog(context, 'Employee'),
              ),
              const SizedBox(height: 14),

              // ── Role 3: WATCHMAN ────────────────────────────────────────
              _buildRoleCard(
                context,
                title: 'I am a',
                role: 'WATCHMAN',
                subtitle: 'Login as Watchman',
                icon: Icons.shield_outlined,
                color: AppColors.pending,
                onTap: () => _showRoleDialog(context, 'Watchman'),
              ),

              const Spacer(),

              // Footer Note
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Secure  •  Smart  •  Contactless  •  Efficient',
                    style: TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String role,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$title ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

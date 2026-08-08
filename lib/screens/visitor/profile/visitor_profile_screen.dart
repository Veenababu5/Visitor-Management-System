import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/visitor_provider.dart';
import '../welcome/role_selection_screen.dart';

class VisitorProfileScreen extends StatelessWidget {
  const VisitorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final visitorProv = Provider.of<VisitorProvider>(context);

    final session = authProv.currentSession;
    final visitor = visitorProv.visitor;

    final name = (session?.name.isNotEmpty == true)
        ? session!.name
        : (visitor?.name.isNotEmpty == true ? visitor!.name : 'Visitor Profile');
    final mobile = (session?.mobile.isNotEmpty == true)
        ? session!.mobile
        : (visitor?.mobile.isNotEmpty == true ? visitor!.mobile : 'Not provided');
    final email = (session?.email.isNotEmpty == true)
        ? session!.email
        : (visitor?.email.isNotEmpty == true ? visitor!.email : 'Not provided');
    final company = (session?.company.isNotEmpty == true)
        ? session!.company
        : (visitor?.company.isNotEmpty == true ? visitor!.company : 'Not provided');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Avatar & Name
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.navyPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Personal Information Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Mobile', mobile),
                    const SizedBox(height: 10),
                    _buildInfoRow('Email', email),
                    const SizedBox(height: 10),
                    _buildInfoRow('Company', company),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ID Verification status row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ID Verification',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.check_circle, size: 14, color: AppColors.approved),
                        SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.approved,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Navigation options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Edit Profile', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    ListTile(
                      title: const Text('Privacy & Security', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sign Out Text Button
              TextButton(
                onPressed: () {
                  authProv.logout();
                  visitorProv.clearProfile();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppColors.rejected,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

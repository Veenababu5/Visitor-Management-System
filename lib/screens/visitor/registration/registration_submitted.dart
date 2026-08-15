import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/registration_provider.dart';
import '../home/visitor_home_screen.dart';

class RegistrationSubmittedScreen extends StatelessWidget {
  const RegistrationSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final regProvider = Provider.of<RegistrationProvider>(context);

    final visitorName = regProvider.fullName.isNotEmpty ? regProvider.fullName : 'Visitor';
    final companyName = regProvider.companyName.isNotEmpty ? regProvider.companyName : 'Organization';
    final hostName = regProvider.personToMeet.isNotEmpty ? regProvider.personToMeet : 'Anu Thomas';
    final department = regProvider.department.isNotEmpty ? regProvider.department : 'IT Department';
    final date = regProvider.appointmentDate.isNotEmpty ? regProvider.appointmentDate : '06 Aug 2026';
    final time = regProvider.expectedArrival.isNotEmpty ? regProvider.expectedArrival : '10:30 AM';
    final purpose = regProvider.purposeOfVisit.isNotEmpty ? regProvider.purposeOfVisit : 'Meeting';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const VisitorHomeScreen(),
              ),
              (route) => route.isFirst,
            );
          },
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              const Spacer(),
              // Green Checkmark Icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.approved,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Request Submitted',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.approved,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your visit request has been sent to your host.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // Visit Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VISIT DETAILS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: AppColors.blueAccent),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(visitorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(companyName, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.badge_outlined, size: 18, color: AppColors.blueAccent),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Visiting $hostName', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(department, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text('$date  •  $time', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text('Purpose: $purpose', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Amber Awaiting Approval banner inside card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.pendingLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.pendingBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.hourglass_empty, color: AppColors.pending, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Awaiting Approval',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pendingDark,
                                  ),
                                ),
                                Text(
                                  "We'll notify you once your visit is approved.",
                                  style: TextStyle(fontSize: 11, color: AppColors.pendingDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

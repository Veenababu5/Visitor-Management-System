import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_status.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../registration/step1_personal_details.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final visitProv = Provider.of<VisitProvider>(context);
    final userId = authProv.currentSession?.userId ?? '';

    final visits = visitProv.getUserRequests(userId).where(
      (v) => v.status == VisitStatus.completed || v.status == VisitStatus.checkedOut,
    ).toList();

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
        title: const Text('Visit History'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Search & Filter bar
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search visits',
                          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Visit Cards List or EMPTY STATE
              Expanded(
                child: visits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.history, size: 48, color: AppColors.textLight),
                            SizedBox(height: 12),
                            Text(
                              'No past visits',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navyPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Completed visits will appear here.',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: visits.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = visits[index];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    StatusBadge(status: item.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${item.date}  •  ${item.time}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navyPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Meeting with ${item.hostName}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  item.department,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (item.duration.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Duration: ${item.duration}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

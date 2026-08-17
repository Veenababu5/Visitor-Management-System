import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_status.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../pass/digital_pass_screen.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitProv = Provider.of<VisitProvider>(context);
    final visit = visitProv.currentVisit;

    if (visit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Visit Details')),
        body: const Center(child: Text('No visit details selected.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Visit Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StatusBadge(status: visit.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Visitor', visit.visitorName, isBold: true),
                        const SizedBox(height: 14),
                        _buildDetailRow('Visitor ID', visit.visitId),
                        const SizedBox(height: 14),
                        _buildDetailRow('Visiting', visit.hostName, isBold: true),
                        const SizedBox(height: 14),
                        _buildDetailRow('Department', visit.department),
                        const SizedBox(height: 14),
                        _buildDetailRow('Purpose', visit.purpose),
                        const SizedBox(height: 14),
                        _buildDetailRow('Date', visit.date),
                        const SizedBox(height: 14),
                        _buildDetailRow('Time', visit.time),

                        const SizedBox(height: 20),

                        // PENDING Alert Box
                        if (visit.status == VisitStatus.pending)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.pendingLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.pendingBorder),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.hourglass_empty, color: AppColors.pending, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Your request is pending approval.\nWe\'ll notify you once it\'s approved.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.pendingDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // REJECTED Alert Box
                        if (visit.status == VisitStatus.rejected)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.rejectedLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.rejectedBorder),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.cancel_outlined, color: AppColors.rejected, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Your request has been rejected.\nPlease contact your host for more information.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.rejectedDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (visit.status == VisitStatus.approved)
                PrimaryButton(
                  text: 'Download Pass',
                  icon: Icons.download,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DigitalPassScreen(),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.navyPrimary,
          ),
        ),
      ],
    );
  }
}

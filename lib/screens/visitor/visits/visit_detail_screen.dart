import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../../../widgets/buttons/primary_button.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitProv = Provider.of<VisitProvider>(context);
    final visit = visitProv.currentVisit;

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
                        const SizedBox(height: 14),
                        _buildDetailRow('Location', visit.location),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Download Pass',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Visitor Pass PDF...')),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';

class DigitalPassScreen extends StatelessWidget {
  const DigitalPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitProv = Provider.of<VisitProvider>(context);
    final visit = visitProv.currentVisit;

    if (visit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Digital Pass')),
        body: const Center(child: Text('No pass available.')),
      );
    }

    final String qrData =
        '{"visitId":"${visit.visitId}","token":"SECURE_ITG_TOKEN_9988"}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Digital Pass'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ITG VISITOR PASS Header Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: AppColors.navyPrimary,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield, color: AppColors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'ITG VISITOR PASS',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: AppColors.navyPrimary,
                                    child: const Icon(Icons.person, color: AppColors.white, size: 34),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          visit.visitorName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.navyPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Visitor ID: ${visit.visitId}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        StatusBadge(status: visit.status),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: QrImageView(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: 76.0,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                              const Divider(color: AppColors.border),
                              const SizedBox(height: 12),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildGridCell('Visiting', visit.hostName, isBold: true),
                                        const SizedBox(height: 10),
                                        _buildGridCell('Department', visit.department),
                                        const SizedBox(height: 10),
                                        _buildGridCell('Purpose', visit.purpose),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildGridCell('Date', visit.date),
                                        const SizedBox(height: 10),
                                        _buildGridCell('Time', visit.time),
                                        const SizedBox(height: 10),
                                        _buildGridCell('Location', visit.location),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Bottom Validity Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          color: AppColors.navyPrimary,
                          child: Center(
                            child: Text(
                              'Valid: ${visit.date} • 10:15 AM – 12:30 PM',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navyPrimary,
                          side: const BorderSide(color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pass Downloaded to Gallery')),
                          );
                        },
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navyPrimary,
                          side: const BorderSide(color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sharing Pass...')),
                          );
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCell(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: AppColors.navyPrimary,
          ),
        ),
      ],
    );
  }
}

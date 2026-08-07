import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_status.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';

class QrPassScreen extends StatelessWidget {
  const QrPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitProv = Provider.of<VisitProvider>(context);
    final visit = visitProv.currentVisit;
    final bool isApproved = visit.status == VisitStatus.approved;

    final String qrData =
        '{"visitId":"${visit.visitId}","token":"SECURE_ITG_TOKEN_9988"}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Visitor Pass'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StatusBadge(status: visit.status),
                        const SizedBox(height: 16),

                        // ── QR Code logic: Only generate/render if APPROVED ──
                        if (isApproved) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 160.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Scan at Gate 1',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else ...[
                          // Pending / Unapproved State Banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.pendingLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.pendingBorder),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.hourglass_empty_rounded,
                                  color: AppColors.pending,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'QR Pass Unavailable',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pendingDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your visit request is currently ${visit.status.label.toLowerCase()}.\nA QR pass will be generated once your host approves the request.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.pendingDark,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 14),

                        // Visitor Details
                        Align(
                          alignment: Alignment.centerLeft,
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
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Host',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                visit.hostName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Department',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                visit.department,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navyPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Valid',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                isApproved
                                    ? '10:15 AM – 12:30 PM'
                                    : 'Pending Approval',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isApproved
                                      ? AppColors.approvedDark
                                      : AppColors.pendingDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isApproved
                                ? AppColors.approvedLight
                                : AppColors.pendingLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: isApproved
                                    ? AppColors.approved
                                    : AppColors.pending,
                                size: 8,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isApproved
                                    ? 'Valid Visitor Pass'
                                    : 'Awaiting Host Approval',
                                style: TextStyle(
                                  color: isApproved
                                      ? AppColors.approvedDark
                                      : AppColors.pendingDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApproved
                              ? AppColors.navyPrimary
                              : AppColors.textHint,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isApproved
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Added to Wallet!')),
                                );
                              }
                            : null,
                        child: const Text(
                          'Add to Wallet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navyPrimary,
                          side: const BorderSide(
                              color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isApproved
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sharing Visitor Pass...')),
                                );
                              }
                            : null,
                        child: const Text(
                          'Share',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
}

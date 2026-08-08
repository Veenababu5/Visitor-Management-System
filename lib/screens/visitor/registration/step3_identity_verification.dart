import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/registration_provider.dart';
import '../../../providers/visit_provider.dart';
import '../../../providers/visitor_provider.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/step_indicator.dart';
import 'registration_submitted.dart';

class Step3IdentityVerificationScreen extends StatefulWidget {
  const Step3IdentityVerificationScreen({super.key});

  @override
  State<Step3IdentityVerificationScreen> createState() =>
      _Step3IdentityVerificationScreenState();
}

class _Step3IdentityVerificationScreenState
    extends State<Step3IdentityVerificationScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickIdProof(RegistrationProvider regProvider) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: kIsWeb,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.size > 5 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 5MB limit'),
              backgroundColor: AppColors.rejected,
            ),
          );
          return;
        }

        regProvider.setIdProof(
          path: kIsWeb ? null : file.path,
          fileName: file.name,
          bytes: file.bytes,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: AppColors.rejected,
        ),
      );
    }
  }

  Future<void> _takePhoto(RegistrationProvider regProvider) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        regProvider.setPhoto(
          path: kIsWeb ? null : photo.path,
          bytes: bytes,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing photo: $e'),
          backgroundColor: AppColors.rejected,
        ),
      );
    }
  }

  Widget _buildPhotoPreview(RegistrationProvider regProvider) {
    if (regProvider.photoBytes != null) {
      return Image.memory(
        regProvider.photoBytes!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && regProvider.photoPath != null && regProvider.photoPath!.isNotEmpty) {
      return Image.file(
        File(regProvider.photoPath!),
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultPhotoBadge(),
      );
    }
    return _buildDefaultPhotoBadge();
  }

  Widget _buildDefaultPhotoBadge() {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.approved,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, color: AppColors.white, size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    final regProvider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: StepIndicator(currentStep: 2, totalSteps: 3)),
          ),
        ],
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Identity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload your documents',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // ── Upload ID Proof ─────────────────────────────────────────
              const Text(
                'Upload ID Proof',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickIdProof(regProvider),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: regProvider.hasIdProof
                        ? AppColors.approvedLight
                        : AppColors.surfaceGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: regProvider.hasIdProof
                          ? AppColors.approvedBorder
                          : AppColors.border,
                    ),
                  ),
                  child: regProvider.hasIdProof
                      ? Column(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.approved, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              regProvider.idProofFileName ?? 'Document uploaded',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.approvedDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () => regProvider.clearIdProof(),
                              child: const Text('Change',
                                  style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.file_upload_outlined,
                                color: AppColors.navyPrimary,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Upload ID Proof',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navyPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'JPG, PNG, PDF (Max. 5MB)',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textLight),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Visitor Photo ───────────────────────────────────────────
              const Text(
                'Visitor Photo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: regProvider.hasPhoto
                      ? AppColors.approvedLight
                      : AppColors.surfaceGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: regProvider.hasPhoto
                        ? AppColors.approvedBorder
                        : AppColors.border,
                  ),
                ),
                child: regProvider.hasPhoto
                    ? Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: _buildPhotoPreview(regProvider),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Photo captured',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.approvedDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => regProvider.clearPhoto(),
                            child: const Text('Retake',
                                style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.textSecondary,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.navyPrimary,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => _takePhoto(regProvider),
                            child: const Text('Take Photo',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 8),
              const Text(
                'Accepted documents: Government ID • Employee ID • Passport',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),

              const Spacer(),

              PrimaryButton(
                text: 'Continue',
                icon: Icons.arrow_forward,
                onPressed: () {
                  final authProv = Provider.of<AuthProvider>(context, listen: false);
                  final visitorProv = Provider.of<VisitorProvider>(context, listen: false);
                  final visitProv = Provider.of<VisitProvider>(context, listen: false);

                  final userId = authProv.currentSession?.userId ?? 'GUEST_USER';
                  final visitorName = visitorProv.visitor?.name.isNotEmpty == true
                      ? visitorProv.visitor!.name
                      : (regProvider.fullName.isNotEmpty ? regProvider.fullName : 'Visitor');
                  final company = visitorProv.visitor?.company.isNotEmpty == true
                      ? visitorProv.visitor!.company
                      : (regProvider.companyName.isNotEmpty ? regProvider.companyName : 'Organization');

                  visitProv.submitNewVisit(
                    userId: userId,
                    visitorName: visitorName,
                    company: company,
                    host: regProvider.personToMeet,
                    department: regProvider.department,
                    purpose: regProvider.purposeOfVisit,
                    date: regProvider.appointmentDate,
                    time: regProvider.expectedArrival,
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationSubmittedScreen(),
                    ),
                    (route) => false,
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
}

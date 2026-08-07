import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../models/visit_status.dart';

class StatusBadge extends StatelessWidget {
  final VisitStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;
    IconData icon;

    switch (status) {
      case VisitStatus.approved:
        bg = AppColors.approvedLight;
        fg = AppColors.approved;
        text = '✓ APPROVED';
        icon = Icons.check_circle_outline;
        break;
      case VisitStatus.pending:
        bg = AppColors.pendingLight;
        fg = AppColors.pending;
        text = '⏳ AWAITING APPROVAL';
        icon = Icons.hourglass_empty;
        break;
      case VisitStatus.rejected:
        bg = AppColors.rejectedLight;
        fg = AppColors.rejected;
        text = '✕ REJECTED';
        icon = Icons.cancel_outlined;
        break;
      case VisitStatus.completed:
        bg = AppColors.approvedLight;
        fg = AppColors.approved;
        text = '✓ Completed';
        icon = Icons.check_circle;
        break;
      default:
        bg = AppColors.surfaceGrey;
        fg = AppColors.textSecondary;
        text = status.label;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

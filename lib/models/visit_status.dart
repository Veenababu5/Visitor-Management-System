enum VisitStatus {
  pending,
  approved,
  rejected,
  completed,
  checkedIn,
  checkedOut,
  expired,
  overstay,
}

extension VisitStatusExtension on VisitStatus {
  String get label {
    switch (this) {
      case VisitStatus.pending:
        return 'Awaiting Approval';
      case VisitStatus.approved:
        return 'APPROVED';
      case VisitStatus.rejected:
        return 'REJECTED';
      case VisitStatus.completed:
        return 'Completed';
      case VisitStatus.checkedIn:
        return 'Checked In';
      case VisitStatus.checkedOut:
        return 'Checked Out';
      case VisitStatus.expired:
        return 'Expired';
      case VisitStatus.overstay:
        return 'Overstay';
    }
  }
}

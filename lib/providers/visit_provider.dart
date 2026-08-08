import 'package:flutter/material.dart';
import '../models/visit_model.dart';
import '../models/visit_status.dart';

class VisitProvider extends ChangeNotifier {
  // Map of userId -> List<VisitModel> to isolate visit requests per user account
  final Map<String, List<VisitModel>> _userVisitsMap = {};

  // Currently selected visit for details view
  VisitModel? _selectedVisit;

  VisitModel? get currentVisit => _selectedVisit;

  /// Retrieves visit requests for the user.
  /// Seeds 1 Approved appointment (for testing Download Pass / QR code)
  /// and 1 Rejected appointment if the user list has not been created yet.
  List<VisitModel> getUserRequests(String userId) {
    if (!_userVisitsMap.containsKey(userId)) {
      _userVisitsMap[userId] = [
        // 1. Confirmed / Approved Appointment (Pass can be downloaded here)
        VisitModel(
          visitId: 'VST-24081',
          visitorId: userId,
          visitorName: 'Visitor',
          company: 'Organization',
          hostName: 'Anu Thomas',
          department: 'IT Department',
          purpose: 'Meeting',
          category: 'Regular Visitor',
          date: '06 Aug 2026',
          time: '10:30 AM – 12:30 PM',
          status: VisitStatus.approved,
          location: 'ITG Campus, Gate 1',
        ),
        // 2. Rejected Appointment
        VisitModel(
          visitId: 'VST-24056',
          visitorId: userId,
          visitorName: 'Visitor',
          company: 'Organization',
          hostName: 'Sandeep Menon',
          department: 'HR Department',
          purpose: 'Interview',
          category: 'Interview Candidate',
          date: '31 Jul 2026',
          time: '10:00 AM – 11:00 AM',
          status: VisitStatus.rejected,
          location: 'ITG Campus, Gate 1',
        ),
      ];
    }
    return _userVisitsMap[userId]!;
  }

  VisitModel? getUpcomingVisit(String userId) {
    final list = getUserRequests(userId);
    if (list.isEmpty) return null;
    return list.firstWhere(
      (v) => v.status == VisitStatus.approved || v.status == VisitStatus.pending,
      orElse: () => list.first,
    );
  }

  void selectVisit(VisitModel visit) {
    _selectedVisit = visit;
    notifyListeners();
  }

  /// Submits a brand new visit request for the logged-in user.
  /// ALWAYS starts with status `VisitStatus.pending`.
  void submitNewVisit({
    required String userId,
    required String visitorName,
    required String company,
    required String host,
    required String department,
    required String purpose,
    required String date,
    required String time,
  }) {
    final newVisit = VisitModel(
      visitId: 'VST-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      visitorId: userId,
      visitorName: visitorName.isNotEmpty ? visitorName : 'Visitor',
      company: company.isNotEmpty ? company : 'Organization',
      hostName: host.isNotEmpty ? host : 'Host',
      department: department.isNotEmpty ? department : 'Department',
      purpose: purpose.isNotEmpty ? purpose : 'Meeting',
      category: 'Regular Visitor',
      date: date.isNotEmpty ? date : 'Today',
      time: time.isNotEmpty ? time : '10:30 AM',
      status: VisitStatus.pending, // DEFAULT STATUS IS PENDING
      location: 'ITG Campus, Gate 1',
    );

    final requests = getUserRequests(userId);
    requests.insert(0, newVisit);
    _selectedVisit = newVisit;
    notifyListeners();
  }

  void clearUserVisits(String userId) {
    _userVisitsMap.remove(userId);
    _selectedVisit = null;
    notifyListeners();
  }
}

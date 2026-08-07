import 'package:flutter/material.dart';
import '../models/visit_model.dart';
import '../models/visit_status.dart';
import '../repositories/mock/mock_data.dart';

class VisitProvider extends ChangeNotifier {
  VisitModel _currentVisit = MockData.upcomingApprovedVisit;
  final List<VisitModel> _historyVisits = List.from(MockData.historyVisits);

  VisitModel get currentVisit => _currentVisit;
  List<VisitModel> get historyVisits => _historyVisits;

  void setStatus(VisitStatus status) {
    _currentVisit = VisitModel(
      visitId: _currentVisit.visitId,
      visitorId: _currentVisit.visitorId,
      visitorName: _currentVisit.visitorName,
      company: _currentVisit.company,
      hostName: _currentVisit.hostName,
      department: _currentVisit.department,
      purpose: _currentVisit.purpose,
      category: _currentVisit.category,
      date: _currentVisit.date,
      time: _currentVisit.time,
      duration: _currentVisit.duration,
      status: status,
      location: _currentVisit.location,
    );
    notifyListeners();
  }

  void submitNewVisit({
    required String host,
    required String department,
    required String purpose,
    required String date,
    required String time,
  }) {
    _currentVisit = VisitModel(
      visitId: 'VST-24083',
      visitorId: 'VST-24081',
      visitorName: 'Raj Kumar',
      company: 'ABC Technologies',
      hostName: host,
      department: department,
      purpose: purpose,
      category: 'Regular Visitor',
      date: date,
      time: time,
      status: VisitStatus.pending,
      location: 'ITG Campus, Gate 1',
    );
    notifyListeners();
  }
}

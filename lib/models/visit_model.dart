import 'visit_status.dart';

class VisitModel {
  final String visitId;
  final String visitorId;
  final String visitorName;
  final String company;
  final String hostName;
  final String department;
  final String purpose;
  final String category;
  final String date;
  final String time;
  final String duration;
  final VisitStatus status;
  final String location;

  VisitModel({
    required this.visitId,
    required this.visitorId,
    required this.visitorName,
    required this.company,
    required this.hostName,
    required this.department,
    required this.purpose,
    this.category = 'Regular Visitor',
    required this.date,
    required this.time,
    this.duration = '',
    required this.status,
    this.location = 'ITG Campus, Gate 1',
  });
}

import '../../models/visitor_model.dart';
import '../../models/visit_model.dart';
import '../../models/visit_status.dart';
import '../../models/employee_model.dart';

class MockData {
  static final VisitorModel sampleVisitor = VisitorModel(
    visitorId: 'VST-24081',
    name: 'Raj Kumar',
    mobile: '+91 XXXXX XXXXX',
    email: 'raj.kumar@email.com',
    company: 'ABC Technologies',
    idVerificationStatus: 'Verified',
  );

  static final List<EmployeeModel> employees = [
    EmployeeModel(id: 'E1', name: 'Anu Thomas', department: 'Information Technology'),
    EmployeeModel(id: 'E2', name: 'Rahul Nair', department: 'Finance Department'),
    EmployeeModel(id: 'E3', name: 'Sandeep Menon', department: 'HR Department'),
    EmployeeModel(id: 'E4', name: 'Priya Sharma', department: 'Operations'),
  ];

  static final List<String> departments = [
    'Information Technology',
    'Finance Department',
    'HR Department',
    'Operations',
    'Administration',
  ];

  static final List<String> purposes = [
    'Meeting',
    'Interview',
    'Vendor Visit',
    'Delivery',
    'Official Audit',
  ];

  static final List<String> visitCategories = [
    'Regular Visitor',
    'VIP / Guest',
    'Contractor / Vendor',
    'Interview Candidate',
  ];

  static final VisitModel upcomingApprovedVisit = VisitModel(
    visitId: 'VST-24081',
    visitorId: 'VST-24081',
    visitorName: 'Raj Kumar',
    company: 'ABC Technologies',
    hostName: 'Anu Thomas',
    department: 'Information Technology',
    purpose: 'Meeting',
    category: 'Regular Visitor',
    date: '06 Aug 2026',
    time: '10:30 AM – 12:30 PM',
    status: VisitStatus.approved,
    location: 'ITG Campus, Gate 1',
  );

  static final VisitModel pendingVisit = VisitModel(
    visitId: 'VST-24082',
    visitorId: 'VST-24081',
    visitorName: 'Raj Kumar',
    company: 'ABC Technologies',
    hostName: 'Anu Thomas',
    department: 'IT Department',
    purpose: 'Meeting',
    category: 'Regular Visitor',
    date: '06 Aug 2026',
    time: '10:30 AM',
    status: VisitStatus.pending,
    location: 'ITG Campus, Gate 1',
  );

  static final List<VisitModel> historyVisits = [
    VisitModel(
      visitId: 'VST-24070',
      visitorId: 'VST-24081',
      visitorName: 'Raj Kumar',
      company: 'ABC Technologies',
      hostName: 'Anu Thomas',
      department: 'IT Department',
      purpose: 'Meeting',
      date: '04 Aug 2026',
      time: '11:20 AM',
      duration: '1h 35m',
      status: VisitStatus.completed,
    ),
    VisitModel(
      visitId: 'VST-24065',
      visitorId: 'VST-24081',
      visitorName: 'Raj Kumar',
      company: 'ABC Technologies',
      hostName: 'Rahul Nair',
      department: 'Finance Department',
      purpose: 'Meeting',
      date: '18 Jul 2026',
      time: '02:10 PM',
      duration: '1h 10m',
      status: VisitStatus.completed,
    ),
    VisitModel(
      visitId: 'VST-24050',
      visitorId: 'VST-24081',
      visitorName: 'Raj Kumar',
      company: 'ABC Technologies',
      hostName: 'Sandeep Menon',
      department: 'HR Department',
      purpose: 'Meeting',
      date: '02 Jul 2026',
      time: '10:00 AM',
      duration: '45m',
      status: VisitStatus.completed,
    ),
  ];
}

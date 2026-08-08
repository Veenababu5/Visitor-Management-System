import '../../models/employee_model.dart';

class MockData {
  // Master directory data for selection dropdowns & employee typeahead
  static final List<EmployeeModel> employees = [
    EmployeeModel(id: 'E1', name: 'Veena', department: 'IT Department'),
    EmployeeModel(id: 'E2', name: 'Sonal', department: 'Finance Department'),
    EmployeeModel(id: 'E3', name: 'Swanish', department: 'HR Department'),
    EmployeeModel(id: 'E4', name: 'Ved', department: 'Operations'),
    EmployeeModel(id: 'E5', name: 'Priya Sharma', department: 'Administration'),
    EmployeeModel(id: 'E6', name: 'Anu Thomas', department: 'IT Department'),
    EmployeeModel(id: 'E7', name: 'Rahul Nair', department: 'Finance Department'),
    EmployeeModel(id: 'E8', name: 'Sandeep Menon', department: 'HR Department'),
  ];

  static final List<String> departments = [
    'IT Department',
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
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegistrationProvider extends ChangeNotifier {
  int _currentStep = 1;

  // ── Step 1: Basic Details ─────────────────────────────────────────────────
  String fullName = '';
  String mobileNumber = '';
  String emailAddress = '';
  String companyName = '';

  // ── Step 2: Visit Details ─────────────────────────────────────────────────
  String personToMeet = '';
  String department = '';
  String purposeOfVisit = 'Meeting';
  String visitCategory = 'Regular Visitor';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String get appointmentDate {
    if (selectedDate == null) return '';
    return DateFormat('dd MMM yyyy').format(selectedDate!);
  }

  String get expectedArrival {
    if (selectedTime == null) return '';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  // ── Step 3: Identity Verification ─────────────────────────────────────────
  String? idProofPath;
  String? idProofFileName;
  Uint8List? idProofBytes;

  String? photoPath;
  Uint8List? photoBytes;

  bool get hasIdProof =>
      (idProofPath != null && idProofPath!.isNotEmpty) || idProofBytes != null;
  bool get hasPhoto =>
      (photoPath != null && photoPath!.isNotEmpty) || photoBytes != null;

  // ── Step Navigation ───────────────────────────────────────────────────────
  int get currentStep => _currentStep;

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  // ── Step 1 Validation ─────────────────────────────────────────────────────
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return 'Enter a valid 10-digit number';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  String? validateCompany(String? value) {
    if (value == null || value.trim().isEmpty) return 'Company name is required';
    return null;
  }

  bool get isStep1Valid {
    return validateFullName(fullName) == null &&
        validateMobile(mobileNumber) == null &&
        validateEmail(emailAddress) == null &&
        validateCompany(companyName) == null;
  }

  // ── Step 2 Validation ─────────────────────────────────────────────────────
  bool get isStep2Valid {
    return personToMeet.isNotEmpty &&
        department.isNotEmpty &&
        purposeOfVisit.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null;
  }

  // ── File/Photo setters ────────────────────────────────────────────────────
  void setIdProof({String? path, String? fileName, Uint8List? bytes}) {
    idProofPath = path;
    idProofFileName = fileName;
    idProofBytes = bytes;
    notifyListeners();
  }

  void clearIdProof() {
    idProofPath = null;
    idProofFileName = null;
    idProofBytes = null;
    notifyListeners();
  }

  void setPhoto({String? path, Uint8List? bytes}) {
    photoPath = path;
    photoBytes = bytes;
    notifyListeners();
  }

  void clearPhoto() {
    photoPath = null;
    photoBytes = null;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void setPersonToMeet(String name, String dept) {
    personToMeet = name;
    department = dept;
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void resetForm() {
    _currentStep = 1;
    fullName = '';
    mobileNumber = '';
    emailAddress = '';
    companyName = '';
    personToMeet = '';
    department = '';
    purposeOfVisit = 'Meeting';
    visitCategory = 'Regular Visitor';
    selectedDate = null;
    selectedTime = null;
    idProofPath = null;
    idProofFileName = null;
    idProofBytes = null;
    photoPath = null;
    photoBytes = null;
    notifyListeners();
  }
}

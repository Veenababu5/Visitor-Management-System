import 'package:flutter/material.dart';
import '../models/visitor_model.dart';

class VisitorProvider extends ChangeNotifier {
  VisitorModel? _visitor;

  VisitorModel? get visitor => _visitor;
  bool get hasProfile => _visitor != null && _visitor!.name.isNotEmpty;

  void setVisitorProfile({
    required String visitorId,
    required String name,
    required String mobile,
    required String email,
    required String company,
  }) {
    _visitor = VisitorModel(
      visitorId: visitorId.isNotEmpty
          ? visitorId
          : 'VST-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      name: name,
      mobile: mobile,
      email: email,
      company: company,
      idVerificationStatus: 'Verified',
    );
    notifyListeners();
  }

  void clearProfile() {
    _visitor = null;
    notifyListeners();
  }
}

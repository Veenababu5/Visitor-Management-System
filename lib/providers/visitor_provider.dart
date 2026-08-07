import 'package:flutter/material.dart';
import '../models/visitor_model.dart';
import '../repositories/mock/mock_data.dart';

class VisitorProvider extends ChangeNotifier {
  final VisitorModel _visitor = MockData.sampleVisitor;

  VisitorModel get visitor => _visitor;
}

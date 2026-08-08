import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/employee_model.dart';
import '../../../providers/registration_provider.dart';
import '../../../repositories/mock/mock_data.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/step_indicator.dart';
import 'step3_identity_verification.dart';

class Step2VisitDetailsScreen extends StatefulWidget {
  const Step2VisitDetailsScreen({super.key});

  @override
  State<Step2VisitDetailsScreen> createState() => _Step2VisitDetailsScreenState();
}

class _Step2VisitDetailsScreenState extends State<Step2VisitDetailsScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _departmentAutoFilled = false;
  bool _showValidationError = false;

  Future<void> _pickDate(BuildContext context, RegistrationProvider regProvider) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: regProvider.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navyPrimary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      regProvider.setDate(picked);
      setState(() {});
    }
  }

  Future<void> _pickTime(BuildContext context, RegistrationProvider regProvider) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: regProvider.selectedTime ?? const TimeOfDay(hour: 10, minute: 30),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navyPrimary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (picked.hour < 8 || picked.hour >= 18) {
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 8:00 AM and 6:00 PM'),
            backgroundColor: AppColors.pending,
          ),
        );
        return;
      }
      regProvider.setTime(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final regProvider = Provider.of<RegistrationProvider>(context);

    // Default sample selections if empty
    if (regProvider.selectedDate == null) {
      regProvider.setDate(DateTime.now().add(const Duration(days: 1)));
    }
    if (regProvider.selectedTime == null) {
      regProvider.setTime(const TimeOfDay(hour: 10, minute: 30));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: StepIndicator(currentStep: 1, totalSteps: 3)),
          ),
        ],
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visit Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navyPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Who are you visiting?",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Person to Meet (Employee Typeahead Search) ────────
                      const Text(
                        'Person to Meet (Select Employee)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Autocomplete<EmployeeModel>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return MockData.employees;
                          }
                          return MockData.employees.where((emp) =>
                              emp.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ));
                        },
                        displayStringForOption: (emp) => emp.name,
                        onSelected: (EmployeeModel emp) {
                          regProvider.setPersonToMeet(emp.name, emp.department);
                          setState(() {
                            _departmentAutoFilled = true;
                            _showValidationError = false;
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                          if (controller.text.isEmpty && regProvider.personToMeet.isNotEmpty) {
                            controller.text = regProvider.personToMeet;
                          }
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            onChanged: (val) {
                              regProvider.personToMeet = val;
                              if (_departmentAutoFilled) {
                                setState(() => _departmentAutoFilled = false);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Type employee name (e.g. Veena, Sonal, Ved...)',
                              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                              suffixIcon: const Icon(Icons.search, color: AppColors.textLight),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: AppColors.blueAccent, width: 1.5),
                              ),
                              errorText: _showValidationError && regProvider.personToMeet.isEmpty
                                  ? 'Please select or enter an employee to visit'
                                  : null,
                            ),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(8),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 200, maxWidth: 340),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final emp = options.elementAt(index);
                                    return ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.blueLight,
                                        child: Text(
                                          emp.name[0],
                                          style: const TextStyle(
                                            color: AppColors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        emp.name,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        emp.department,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                      onTap: () => onSelected(emp),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_departmentAutoFilled)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: const [
                              Icon(Icons.check_circle, size: 12, color: AppColors.approved),
                              SizedBox(width: 4),
                              Text(
                                'Department auto-filled from employee',
                                style: TextStyle(fontSize: 11, color: AppColors.approved),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 14),

                      // ── Department ────────────────────────────────────────
                      const Text(
                        'Department',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: MockData.departments.contains(regProvider.department)
                            ? regProvider.department
                            : MockData.departments.first,
                        onChanged: (val) {
                          if (val != null) {
                            regProvider.department = val;
                            setState(() {});
                          }
                        },
                        items: MockData.departments
                            .map((dept) => DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept, style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Purpose of Visit ──────────────────────────────────
                      const Text(
                        'Purpose of Visit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: MockData.purposes.contains(regProvider.purposeOfVisit)
                            ? regProvider.purposeOfVisit
                            : MockData.purposes.first,
                        onChanged: (val) {
                          if (val != null) regProvider.purposeOfVisit = val;
                        },
                        items: MockData.purposes
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p, style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Visit Category ────────────────────────────────────
                      const Text(
                        'Visit Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: MockData.visitCategories.contains(regProvider.visitCategory)
                            ? regProvider.visitCategory
                            : MockData.visitCategories.first,
                        onChanged: (val) {
                          if (val != null) regProvider.visitCategory = val;
                        },
                        items: MockData.visitCategories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c, style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Appointment Date ──────────────────────────────────
                      const Text(
                        'Appointment Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickDate(context, regProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                regProvider.appointmentDate.isNotEmpty
                                    ? regProvider.appointmentDate
                                    : 'Select date',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Expected Arrival Time ─────────────────────────────
                      const Text(
                        'Expected Arrival Time',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _pickTime(context, regProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                regProvider.expectedArrival.isNotEmpty
                                    ? regProvider.expectedArrival
                                    : 'Select time',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Notes (Optional) ──────────────────────────────────
                      const Text(
                        'Notes (Optional)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter any additional notes',
                          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                text: 'Continue',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (regProvider.personToMeet.isEmpty) {
                    setState(() => _showValidationError = true);
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Step3IdentityVerificationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

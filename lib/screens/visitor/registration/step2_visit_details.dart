import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/registration_provider.dart';
import '../../../repositories/mock/mock_data.dart';
import '../../../models/employee_model.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/step_indicator.dart';
import 'step3_identity_verification.dart';

class Step2VisitDetailsScreen extends StatefulWidget {
  const Step2VisitDetailsScreen({super.key});

  @override
  State<Step2VisitDetailsScreen> createState() => _Step2VisitDetailsScreenState();
}

class _Step2VisitDetailsScreenState extends State<Step2VisitDetailsScreen> {
  bool _showValidationErrors = false;
  bool _departmentAutoFilled = false;

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
      initialTime: regProvider.selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
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
      // Constrain to business hours 8 AM – 6 PM
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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: StepIndicator(currentStep: 2, totalSteps: 3)),
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
                'Who are you visiting?',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Person to Meet (Typeahead) ────────────────────────
                      const Text(
                        'Person to Meet',
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
                            return const Iterable<EmployeeModel>.empty();
                          }
                          return MockData.employees.where((emp) =>
                              emp.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ));
                        },
                        displayStringForOption: (emp) => emp.name,
                        onSelected: (EmployeeModel emp) {
                          regProvider.setPersonToMeet(emp.name, emp.department);
                          setState(() => _departmentAutoFilled = true);
                        },
                        fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                          // Pre-populate controller if provider has a value
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
                              hintText: 'Search employee...',
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
                              errorText: _showValidationErrors && regProvider.personToMeet.isEmpty
                                  ? 'Please select a person to meet'
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
                                      title: Text(emp.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                      subtitle: Text(emp.department, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
                                'Department auto-filled',
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
                            : null,
                        onChanged: _departmentAutoFilled
                            ? null
                            : (val) {
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
                          hintText: 'Select department',
                          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          errorText: _showValidationErrors && regProvider.department.isEmpty
                              ? 'Please select a department'
                              : null,
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
                            : null,
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
                            : null,
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

                      // ── Appointment Date & Expected Arrival ───────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: _showValidationErrors && regProvider.selectedDate == null
                                            ? AppColors.rejected
                                            : AppColors.border,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          regProvider.appointmentDate.isNotEmpty
                                              ? regProvider.appointmentDate
                                              : 'Select date',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: regProvider.appointmentDate.isNotEmpty
                                                ? AppColors.textPrimary
                                                : AppColors.textHint,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showValidationErrors && regProvider.selectedDate == null)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4, left: 4),
                                    child: Text(
                                      'Required',
                                      style: TextStyle(fontSize: 11, color: AppColors.rejected),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expected Arrival',
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
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                        color: _showValidationErrors && regProvider.selectedTime == null
                                            ? AppColors.rejected
                                            : AppColors.border,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          regProvider.expectedArrival.isNotEmpty
                                              ? regProvider.expectedArrival
                                              : 'Select time',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: regProvider.expectedArrival.isNotEmpty
                                                ? AppColors.textPrimary
                                                : AppColors.textHint,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showValidationErrors && regProvider.selectedTime == null)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4, left: 4),
                                    child: Text(
                                      'Required',
                                      style: TextStyle(fontSize: 11, color: AppColors.rejected),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
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
                  setState(() => _showValidationErrors = true);
                  if (regProvider.isStep2Valid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Step3IdentityVerificationScreen(),
                      ),
                    );
                  }
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

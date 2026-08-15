import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_model.dart';
import '../../../models/visit_status.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../home/visitor_home_screen.dart';
import '../visits/visit_detail_screen.dart';

class VisitRequestsScreen extends StatefulWidget {
  const VisitRequestsScreen({super.key});

  @override
  State<VisitRequestsScreen> createState() => _VisitRequestsScreenState();
}

class _VisitRequestsScreenState extends State<VisitRequestsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final visitProv = Provider.of<VisitProvider>(context);
    final userId = authProv.currentSession?.userId ?? '';

    final userRequests = visitProv.getUserRequests(userId);

    List<VisitModel> displayedRequests = userRequests;
    if (_selectedFilter == 'Pending') {
      displayedRequests = userRequests.where((r) => r.status == VisitStatus.pending).toList();
    } else if (_selectedFilter == 'Approved') {
      displayedRequests = userRequests.where((r) => r.status == VisitStatus.approved).toList();
    } else if (_selectedFilter == 'Rejected') {
      displayedRequests = userRequests.where((r) => r.status == VisitStatus.rejected).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const VisitorHomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text('Visit Requests'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Filter Tabs Pill Bar
              Row(
                children: ['All', 'Pending', 'Approved', 'Rejected'].map((tab) {
                  final isSelected = _selectedFilter == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = tab),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.navyPrimary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.navyPrimary : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            tab,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Request Cards List or EMPTY STATE
              Expanded(
                child: displayedRequests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_open_outlined,
                              size: 48,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No visitor requests yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navyPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your submitted visit requests will appear here.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: displayedRequests.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = displayedRequests[index];
                          return GestureDetector(
                            onTap: () {
                              visitProv.selectVisit(item);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VisitDetailScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.hostName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.navyPrimary,
                                          ),
                                        ),
                                        Text(
                                          item.department,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${item.date}  •  ${item.time}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusBadge(status: item.status),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

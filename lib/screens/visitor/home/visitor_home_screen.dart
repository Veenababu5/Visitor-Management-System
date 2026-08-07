import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_status.dart';
import '../../../providers/visit_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../pass/qr_pass_screen.dart';
import '../visits/visit_detail_screen.dart';
import '../visits/visit_history_screen.dart';
import '../profile/visitor_profile_screen.dart';

class VisitorHomeScreen extends StatefulWidget {
  const VisitorHomeScreen({super.key});

  @override
  State<VisitorHomeScreen> createState() => _VisitorHomeScreenState();
}

class _VisitorHomeScreenState extends State<VisitorHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final visitProv = Provider.of<VisitProvider>(context);
    final currentVisit = visitProv.currentVisit;

    final List<Widget> pages = [
      _buildHomeTab(context, currentVisit),
      const VisitHistoryScreen(),
      const VisitorProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: AppColors.navyPrimary,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Row(
                children: [
                  Text(
                    'ITG',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: AppColors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.white),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.navyPrimary,
        unselectedItemColor: AppColors.textLight,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Visits'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, dynamic currentVisit) {
    final bool isApproved = currentVisit.status == VisitStatus.approved;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello, Raj 👋',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.navyPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Visit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              // Mock toggle button to test Approved vs Pending QR behavior
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  final prov = Provider.of<VisitProvider>(context, listen: false);
                  if (isApproved) {
                    prov.setStatus(VisitStatus.pending);
                  } else {
                    prov.setStatus(VisitStatus.approved);
                  }
                },
                icon: const Icon(Icons.swap_horiz, size: 14, color: AppColors.blueAccent),
                label: Text(
                  isApproved ? 'Test Pending' : 'Test Approve',
                  style: const TextStyle(fontSize: 11, color: AppColors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Upcoming Visit Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadge(status: currentVisit.status),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentVisit.date.toUpperCase(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isApproved
                                  ? AppColors.approvedDark
                                  : AppColors.pendingDark,
                            ),
                          ),
                          Text(
                            currentVisit.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Meeting with\n${currentVisit.hostName}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyPrimary,
                            ),
                          ),
                          Text(
                            currentVisit.department,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Meeting illustration placeholder
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.blueLight.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.groups_outlined,
                        size: 44,
                        color: AppColors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Button: QR CODE (Conditional behavior based on status)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApproved
                          ? AppColors.navyPrimary
                          : AppColors.surfaceGrey,
                      foregroundColor: isApproved
                          ? AppColors.white
                          : AppColors.textSecondary,
                      elevation: 0,
                      side: isApproved
                          ? BorderSide.none
                          : const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QrPassScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      isApproved ? Icons.qr_code : Icons.lock_clock,
                      size: 20,
                      color: isApproved ? AppColors.white : AppColors.pending,
                    ),
                    label: Text(
                      isApproved
                          ? 'QR CODE'
                          : 'QR PASS (Awaiting Approval)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isApproved ? 14 : 12,
                        letterSpacing: isApproved ? 0.5 : 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Button: View Visit Details
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navyPrimary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VisitDetailScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View Visit Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

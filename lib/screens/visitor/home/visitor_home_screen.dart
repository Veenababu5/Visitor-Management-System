import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/visit_status.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/visit_provider.dart';
import '../../../providers/visitor_provider.dart';
import '../../../widgets/badges/status_badge.dart';
import '../registration/step2_visit_details.dart';
import '../requests/visit_requests_screen.dart';
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
    final authProv = Provider.of<AuthProvider>(context);
    final userId = authProv.currentSession?.userId ?? '';

    final List<Widget> pages = [
      _buildHomeTab(context, userId),
      const Step2VisitDetailsScreen(),
      const VisitHistoryScreen(),
      const VisitRequestsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Step2VisitDetailsScreen()),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        selectedItemColor: AppColors.navyPrimary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document), label: 'Register for Visit'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Visit History'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Visit Requests'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context, String userId) {
    final visitorProv = Provider.of<VisitorProvider>(context);
    final visitProv = Provider.of<VisitProvider>(context);

    final visitor = visitorProv.visitor;
    final displayName = (visitor != null && visitor.name.isNotEmpty)
        ? visitor.name.split(' ').first
        : 'Visitor';

    final upcomingVisit = visitProv.getUpcomingVisit(userId);
    final canPop = Navigator.canPop(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Navy Header Banner ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.navyPrimary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (canPop)
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppColors.white),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        if (canPop) const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.navyMedium,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'ITG',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VisitorProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.navyMedium,
                          child: Icon(Icons.person, color: AppColors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Hello, $displayName 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Visits',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                    if (upcomingVisit != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VisitRequestsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueAccent,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                if (upcomingVisit == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 40,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No upcoming visits',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Create a new visit request to get started.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navyPrimary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Step2VisitDetailsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Register for a Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      visitProv.selectVisit(upcomingVisit);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VisitDetailScreen(),
                        ),
                      );
                    },
                    child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceGrey,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      upcomingVisit.date.split(' ').first,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.navyPrimary,
                                      ),
                                    ),
                                    Text(
                                      upcomingVisit.date.split(' ').length > 1
                                          ? upcomingVisit.date.split(' ')[1].toUpperCase()
                                          : 'AUG',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          upcomingVisit.time,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        StatusBadge(status: upcomingVisit.status),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Meeting with ${upcomingVisit.hostName}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.navyPrimary,
                                      ),
                                    ),
                                    Text(
                                      upcomingVisit.department,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                upcomingVisit.location,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Recent Notifications',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: upcomingVisit == null
                      ? const Row(
                          children: [
                            Icon(Icons.notifications_none, color: AppColors.textLight, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'No notifications yet',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: upcomingVisit.status == VisitStatus.approved
                                    ? AppColors.approvedLight
                                    : AppColors.pendingLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.notifications_active_outlined,
                                color: upcomingVisit.status == VisitStatus.approved
                                    ? AppColors.approved
                                    : AppColors.pending,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your visit request for ${upcomingVisit.hostName} is ${upcomingVisit.status.label.toLowerCase()}.',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.navyPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Just now',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

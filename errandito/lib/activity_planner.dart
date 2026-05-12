import 'package:flutter/material.dart';

class ActivityPlannerPage extends StatelessWidget {
  const ActivityPlannerPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color textColor = Color(0xFF0D2C3A);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  static const List<ActivityPlan> plans = [
    ActivityPlan(
      time: '08:00',
      task: 'Nearby errands: 5 available',
      state: ActivityState.done,
    ),
    ActivityPlan(
      time: '10:30',
      task: 'Earnings preview: ₱320 today',
      state: ActivityState.active,
    ),
    ActivityPlan(
      time: '13:00',
      task: 'Quick stats: 2 accepted tasks',
      state: ActivityState.idle,
    ),
    ActivityPlan(
      time: '15:00',
      task: 'Quick stats: 1 completed task',
      state: ActivityState.idle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 124),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Runner Home',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Material(
                        color: teal,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pushNamed(context, '/home-dashboard');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0C2D3F).withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'May 2026',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            CalendarDay(label: 'Mon'),
                            CalendarDay(label: 'Tue'),
                            CalendarDay(label: 'Wed'),
                            CalendarDay(label: 'Thu'),
                            CalendarDay(label: 'Fri'),
                            CalendarDay(label: 'Sat'),
                            CalendarDay(label: 'Sun'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            CalendarDateButton(
                              date: '5',
                              isActive: false,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '6',
                              isActive: false,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '7',
                              isActive: true,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '8',
                              isActive: false,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '9',
                              isActive: false,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '10',
                              isActive: false,
                              onTap: () {},
                            ),
                            CalendarDateButton(
                              date: '11',
                              isActive: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0C2D3F).withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Stats',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...plans.map(
                          (plan) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: FlowCard(plan: plan),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            navy,
                            teal,
                          ],
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(context, '/gig-finder');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(14),
                            child: Text(
                              'View Available Errands',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RunnerBottomNav(active: 'home'),
          ),
        ],
      ),
    );
  }
}

class CalendarDay extends StatelessWidget {
  final String label;

  const CalendarDay({
    super.key,
    required this.label,
  });

  static const Color textColor = Color(0xFF0D2C3A);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CalendarDateButton extends StatelessWidget {
  final String date;
  final bool isActive;
  final VoidCallback onTap;

  const CalendarDateButton({
    super.key,
    required this.date,
    required this.isActive,
    required this.onTap,
  });

  static const Color teal = Color(0xFF005477);
  static const Color inactiveBg = Color(0xFFEDF2F6);
  static const Color textColor = Color(0xFF0D2C3A);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Material(
          color: isActive ? teal : inactiveBg,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlowCard extends StatelessWidget {
  final ActivityPlan plan;

  const FlowCard({
    super.key,
    required this.plan,
  });

  static const Color textColor = Color(0xFF0D2C3A);

  Color get backgroundColor {
    switch (plan.state) {
      case ActivityState.done:
        return const Color(0xFFE5F3EC);
      case ActivityState.active:
        return const Color(0xFFE6F2F8);
      case ActivityState.idle:
        return const Color(0xFFF2F4F7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              plan.time,
              style: const TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              plan.task,
              style: const TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityPlan {
  final String time;
  final String task;
  final ActivityState state;

  const ActivityPlan({
    required this.time,
    required this.task,
    required this.state,
  });
}

enum ActivityState {
  done,
  active,
  idle,
}

class RunnerBottomNav extends StatelessWidget {
  final String active;

  const RunnerBottomNav({
    super.key,
    required this.active,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color muted = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isActive: active == 'home',
            onTap: () {
              Navigator.pushNamed(context, '/activity-planner');
            },
          ),
          BottomNavItem(
            icon: Icons.search_outlined,
            label: 'Errands',
            isActive: active == 'errands',
            onTap: () {
              Navigator.pushNamed(context, '/gig-finder');
            },
          ),
          BottomNavItem(
            icon: Icons.assignment_outlined,
            label: 'Status',
            isActive: active == 'status',
            onTap: () {
              Navigator.pushNamed(context, '/execution-status');
            },
          ),
          BottomNavItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Earnings',
            isActive: active == 'earnings',
            onTap: () {
              Navigator.pushNamed(context, '/payment-earnings');
            },
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color muted = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? navy : muted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StewardWalletBudgetAllocatedPage extends StatelessWidget {
  const StewardWalletBudgetAllocatedPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color green = Color(0xFF004035);
  static const Color darkGreen = Color(0xFF17584C);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color panel = Color(0xFFF2F3F7);

  static const List<ActivityItem> activities = [
    ActivityItem(
      title: 'Gourmet Grocery Run',
      subtitle: 'Allocated Budget • 12 mins ago',
      amount: '+\$42.50',
      tag: 'Budget Load',
      tone: ActivityTone.positive,
    ),
    ActivityItem(
      title: 'Task Completion Bonus',
      subtitle: 'Personal Earnings • Yesterday',
      amount: '+\$15.00',
      tag: 'Payout',
      tone: ActivityTone.positive,
    ),
    ActivityItem(
      title: 'Bank Transfer',
      subtitle: 'External Account • Oct 24',
      amount: '-\$500.00',
      tag: 'Withdrawal',
      tone: ActivityTone.negative,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  color: const Color(0xFFF8FAFC).withOpacity(0.90),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFD6E5EC),
                                    child: const Icon(
                                      Icons.person,
                                      color: navy,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Hi, Bronny',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: navy,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 124),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: navy,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ratings, verification, earnings history, premium, and logout.',
                            style: TextStyle(
                              color: bodyText,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF191C1E).withOpacity(0.06),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'EARNINGS HISTORY',
                                  style: TextStyle(
                                    color: bodyText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.72,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '₱1,284.50',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [navy, teal],
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/errand-execution-payment',
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            'View Earnings',
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

                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withOpacity(0.12),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'VERIFICATION',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.75),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.72,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB1EFDE),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Color(0xFF00201A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '4.9 / 5.0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Ratings and trust status are visible to requesters.',
                                  style: TextStyle(
                                    color: Color(0xFFC7E7FF),
                                    fontSize: 14,
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Premium options available',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Activity History',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'View All',
                                  style: TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Column(
                            children: activities.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: HistoryItem(activity: item),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 8),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Premium and Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Access premium convenience features and sign out from profile.',
                                  style: TextStyle(
                                    color: Color(0xFF95D3C3),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RunnerBottomNav(active: 'profile'),
          ),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final ActivityItem activity;

  const HistoryItem({
    super.key,
    required this.activity,
  });

  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color green = Color(0xFF004035);

  @override
  Widget build(BuildContext context) {
    final bool isNegative = activity.tone == ActivityTone.negative;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                activity.amount,
                style: TextStyle(
                  color: isNegative ? const Color(0xFF9B1C1C) : green,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isNegative
                      ? const Color(0xFFF3D7D7)
                      : const Color(0xFFB1EFDE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  activity.tag,
                  style: TextStyle(
                    color: isNegative
                        ? const Color(0xFF7A1212)
                        : const Color(0xFF00201A),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String amount;
  final String tag;
  final ActivityTone tone;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.tag,
    required this.tone,
  });
}

enum ActivityTone {
  positive,
  negative,
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
            label: 'Tasks',
            isActive: active == 'tasks',
            onTap: () {
              Navigator.pushNamed(context, '/execution-status');
            },
          ),
          BottomNavItem(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            isActive: active == 'messages',
            onTap: () {
              Navigator.pushNamed(context, '/execution-messaging');
            },
          ),
          BottomNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: active == 'profile',
            onTap: () {},
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

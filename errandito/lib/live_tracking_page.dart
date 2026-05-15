import 'package:flutter/material.dart';

class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color green = Color(0xFF004035);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
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
                                child: const Icon(Icons.person, color: navy),
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
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 134),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7E7FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'In Transit',
                              style: TextStyle(
                                color: Color(0xFF001E2E),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Active Delivery',
                            style: TextStyle(
                              color: navy,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Order #ST-9402 • Grocery Concierge',
                            style: TextStyle(color: bodyText, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ETA Arrival: 12 mins',
                              style: TextStyle(
                                color: navy,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF191C1E,
                                  ).withOpacity(0.06),
                                  blurRadius: 48,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 340,
                                  child: Image.asset(
                                    'assets/images/map_pins.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFECEEF1),
                                        child: const Center(
                                          child: Icon(
                                            Icons.map_outlined,
                                            color: navy,
                                            size: 64,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: SizedBox(
                                            width: 46,
                                            height: 48,
                                            child: Image.asset(
                                              'assets/images/helper.png',
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: const Color(
                                                        0xFFD6E5EC,
                                                      ),
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
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Christian Jorda',
                                                style: TextStyle(
                                                  color: navy,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                '4.9 • 1.2k Tasks',
                                                style: TextStyle(
                                                  color: bodyText,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: lightPanel,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Journey',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 12),
                                JourneyStep(
                                  number: 1,
                                  label: 'Order Confirmed',
                                  color: green,
                                  isBold: true,
                                ),
                                JourneyStep(
                                  number: 2,
                                  label: 'Picked up',
                                  color: green,
                                  isBold: true,
                                ),
                                JourneyStep(
                                  number: 3,
                                  label: 'In Transit',
                                  color: navy,
                                  isBold: true,
                                ),
                                JourneyStep(
                                  number: 4,
                                  label: 'Arriving',
                                  color: mutedText,
                                  isBold: false,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: lightPanel,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 12),
                                ActivityNote(
                                  text:
                                      'Christian substituted "Organic Kale" with "Standard Kale" as requested.',
                                ),
                                SizedBox(height: 8),
                                ActivityNote(
                                  text:
                                      'All cold items placed in thermal cooling bags.',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [navy, teal],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: navy.withOpacity(0.20),
                                    blurRadius: 48,
                                    offset: const Offset(0, 24),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/task-complete',
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(18),
                                    child: Text(
                                      'Mark Task Complete',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
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
                ),
              ),
            ],
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RequesterBottomNav(active: 'tasks'),
          ),
        ],
      ),
    );
  }
}

class JourneyStep extends StatelessWidget {
  final int number;
  final String label;
  final Color color;
  final bool isBold;

  const JourneyStep({
    super.key,
    required this.number,
    required this.label,
    required this.color,
    required this.isBold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityNote extends StatelessWidget {
  final String text;

  const ActivityNote({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF40484E),
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }
}

class RequesterBottomNav extends StatelessWidget {
  final String active;

  const RequesterBottomNav({super.key, required this.active});

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF191C1E).withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: active == 'home',
              onTap: () {
                Navigator.pushNamed(context, '/home-dashboard');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.grid_view_outlined,
              label: 'Services',
              isActive: active == 'services',
              onTap: () {
                Navigator.pushNamed(context, '/servicehub');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Messages',
              isActive: active == 'messages',
              onTap: () {
                Navigator.pushNamed(context, '/message');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.assignment_outlined,
              label: 'Activity',
              isActive: active == 'activity',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/activity');
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: active == 'profile',
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? navy : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isActive ? Colors.white : inactive, size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : inactive,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

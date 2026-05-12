import 'package:flutter/material.dart';

class AccountCreatedPage extends StatelessWidget {
  const AccountCreatedPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color green = Color(0xFF004035);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightText = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 390,
                height: 1344,
                child: Stack(
                  children: [
                    Positioned(
                      left: 131,
                      top: 12,
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 28,
                              top: 20,
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: green.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 40,
                              top: 34,
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: green,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: green.withOpacity(0.15),
                                      blurRadius: 48,
                                      offset: const Offset(0, 24),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 56,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 24,
                      top: 224,
                      child: SizedBox(
                        width: 320,
                        child: Column(
                          children: const [
                            Text(
                              'Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                height: 1.11,
                                letterSpacing: -0.9,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Manage your account, ratings, and plan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: bodyText,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 24,
                      top: 400,
                      child: SizedBox(
                        width: 342,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3F7),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -134,
                                bottom: -52,
                                child: Container(
                                  width: 171,
                                  height: 345,
                                  color:
                                      const Color(0xFFE7E8EB).withOpacity(0.5),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.location_on,
                                        color: green,
                                        size: 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'PROFILE',
                                        style: TextStyle(
                                          color: green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Bronny James',
                                    style: TextStyle(
                                      color: darkText,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      height: 1.28,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Email: bronny@example.com\n'
                                    'Contact: 09XX-XXX-XXXX\n'
                                    'School/Org: Panabo Campus\n'
                                    'Rating: 4.9 (128 reviews)',
                                    style: TextStyle(
                                      color: bodyText,
                                      fontSize: 14,
                                      height: 1.42,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ProfilePillButton(
                                        label: 'Ratings & Reviews',
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/task-complete',
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      ProfilePillButton(
                                        label: 'Premium Plan',
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/reviewpay',
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      ProfilePillButton(
                                        label: 'Logout',
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/login',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 24,
                      top: 869,
                      child: SizedBox(
                        width: 342,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 64,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      navy,
                                      teal,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: navy.withOpacity(0.12),
                                      blurRadius: 48,
                                      offset: const Offset(0, 24),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/identity',
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Verify Identity',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            height: 1.55,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/reviewpay');
                                },
                                child: const Text(
                                  'Premium',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 57,
                      top: 1146,
                      child: SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            TrustItem(
                              icon: Icons.verified_outlined,
                              label: 'Ratings',
                            ),
                            TrustSeparator(),
                            TrustItem(
                              icon: Icons.shield_outlined,
                              label: 'Settings',
                            ),
                            TrustSeparator(),
                            TrustItem(
                              icon: Icons.handshake_outlined,
                              label: 'Logout',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 90,
                      child: Text(
                        'ERRANDITO • Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RequesterBottomNav(active: 'profile'),
          ),
        ],
      ),
    );
  }
}

class ProfilePillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ProfilePillButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  static const Color textColor = Color(0xFF536167);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: null,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFC0C7CE).withOpacity(0.15),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const TrustItem({
    super.key,
    required this.icon,
    required this.label,
  });

  static const Color iconColor = Color(0xFF71787E);
  static const Color labelColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: labelColor,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class TrustSeparator extends StatelessWidget {
  const TrustSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.only(top: 16),
      color: const Color(0xFFC0C7CE).withOpacity(0.30),
    );
  }
}

class RequesterBottomNav extends StatelessWidget {
  final String active;

  const RequesterBottomNav({
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
            onTap: () => Navigator.pushNamed(context, '/home-dashboard'),
          ),
          BottomNavItem(
            icon: Icons.receipt_long_outlined,
            label: 'Tasks',
            isActive: active == 'tasks',
            onTap: () => Navigator.pushNamed(context, '/task-complete'),
          ),
          BottomNavItem(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            isActive: active == 'messages',
            onTap: () {},
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

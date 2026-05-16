import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class AccountCreatedPage extends StatelessWidget {
  const AccountCreatedPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color cardBorder = Color(0xFFE6E9EF);
  static const Color optionBg = Color(0xFFF2F3F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool shortScreen = constraints.maxHeight < 720;
            final bool narrowScreen = constraints.maxWidth <= 390;

            final double horizontalPadding = narrowScreen ? 18 : 24;
            final double headerHeight = shortScreen ? 138 : 154;
            final double cardOverlap = shortScreen ? -30 : -36;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    children: [
                      ProfileTopHeader(
                        height: headerHeight,
                        onBack: () {
                          Navigator.pushNamed(context, '/home-dashboard');
                        },
                        onMenu: () {},
                      ),
                      Transform.translate(
                        offset: Offset(0, cardOverlap),
                        child: const ProfileMainCard(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileTopHeader extends StatelessWidget {
  final double height;
  final VoidCallback onBack;
  final VoidCallback onMenu;

  const ProfileTopHeader({
    super.key,
    required this.height,
    required this.onBack,
    required this.onMenu,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, teal],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(right: 20, top: 22, child: HeaderMinimalPattern()),
          Positioned(
            left: 16,
            right: 16,
            top: 26,
            child: SizedBox(
              height: 42,
              child: Row(
                children: [
                  HeaderCircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: onBack,
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                  HeaderCircleButton(
                    icon: Icons.more_vert_rounded,
                    onTap: onMenu,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderMinimalPattern extends StatelessWidget {
  const HeaderMinimalPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 86),
      painter: HeaderPatternPainter(),
    );
  }
}

class HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.11)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.16)
      ..style = PaintingStyle.fill;

    final Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.36),
      38,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.36),
      18,
      circlePaint,
    );

    final Path path = Path()
      ..moveTo(8, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.20,
        size.width * 0.55,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.58,
        size.width - 10,
        size.height * 0.22,
      );

    canvas.drawPath(path, linePaint);

    canvas.drawCircle(Offset(8, size.height * 0.72), 2.4, dotPaint);
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.42),
      2.4,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width - 10, size.height * 0.22),
      2.4,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeaderCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HeaderCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.14),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 19),
        ),
      ),
    );
  }
}

class ProfileMainCard extends StatelessWidget {
  const ProfileMainCard({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color cardBorder = Color(0xFFE6E9EF);

  Future<void> _logout(BuildContext context) async {
    await AuthService.signOut();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProfileAvatar(),
          const SizedBox(height: 12),

          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: AuthService.currentUserStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Column(
                  children: [
                    Text(
                      'User',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'No email found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }

              final Map<String, dynamic>? data = snapshot.data!.data();

              final String fullName = data?['fullName'] ?? 'User';
              final String email = data?['email'] ?? '';
              final String role = data?['role'] ?? '';

              return Column(
                children: [
                  Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role == 'runner' ? 'Runner' : 'Requester',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: teal.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: teal, size: 14),
                SizedBox(width: 5),
                Text(
                  'Verified ERRANDITO User',
                  style: TextStyle(
                    color: teal,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const ProfileStatsRow(),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Account'),
          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.badge_outlined,
            title: 'Identity Verification',
            subtitle: 'Manage your ID and verification status.',
            onTap: () {
              Navigator.pushNamed(context, '/identity');
            },
          ),

          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.receipt_long_outlined,
            title: 'My Errands',
            subtitle: 'View active, completed, and cancelled tasks.',
            onTap: () {
              Navigator.pushNamed(context, '/task-complete');
            },
          ),

          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.star_border_rounded,
            title: 'Ratings & Reviews',
            subtitle: 'See your feedback from requesters and runners.',
            onTap: () {
              Navigator.pushNamed(context, '/task-complete');
            },
          ),

          const SizedBox(height: 18),
          const SectionTitle(title: 'Settings'),
          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Premium Plan',
            subtitle: 'Priority matching and express booking.',
            onTap: () {
              Navigator.pushNamed(context, '/reviewpay');
            },
          ),

          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.help_outline_rounded,
            title: 'Help Centre',
            subtitle: 'Get support for errands, payments, and safety.',
            onTap: () {},
          ),

          const SizedBox(height: 10),

          ProfileOptionTile(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Sign out of your account.',
            isDestructive: true,
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 43,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: navy.withOpacity(0.10),
        child: ClipOval(
          child: Image.asset(
            'assets/images/profile.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [navy, teal],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ProfileStatItem(value: '128', label: 'Errands'),
        ),
        Expanded(
          child: ProfileStatItem(value: '4.9', label: 'Rating'),
        ),
        Expanded(
          child: ProfileStatItem(value: '₱6k', label: 'Earnings'),
        ),
      ],
    );
  }
}

class ProfileStatItem extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatItem({super.key, required this.value, required this.label});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: navy,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color optionBg = Color(0xFFF2F3F7);
  static const Color danger = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isDestructive ? danger : navy;

    return Material(
      color: optionBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: activeColor, size: 17),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: activeColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: activeColor.withOpacity(0.75),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';
import 'services/errand_service.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  static const Color background = Color(0xFFF8F9FD);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool compact = screenWidth <= 390;
    final double horizontalPadding = compact ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                112,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeroHeader(
                        onProfileTap: () {
                          Navigator.pushReplacementNamed(context, '/profile');
                        },
                        onNotificationTap: () {},
                        onFilterTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/servicehub',
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      const MainActionsCarousel(),

                      const SizedBox(height: 24),

                      SectionHeader(
                        title: 'Services',
                        actionText: 'View All',
                        onActionTap: () {
                          Navigator.pushNamed(context, '/servicehub');
                        },
                      ),

                      const SizedBox(height: 12),

                      const ServiceGrid(),

                      const SizedBox(height: 24),

                      SectionHeader(
                        title: 'Active Errands',
                        actionText: 'View All',
                        onActionTap: () {
                          Navigator.pushReplacementNamed(context, '/activity');
                        },
                      ),

                      const SizedBox(height: 12),

                      const ActiveErrandsList(),

                      const SizedBox(height: 24),

                      SectionHeader(
                        title: 'Top Runners Near You',
                        actionText: 'See All',
                        onActionTap: () {},
                      ),

                      const SizedBox(height: 12),

                      const RunnerList(),
                    ],
                  ),
                ),
              ),
            ),

            const Align(
              alignment: Alignment.bottomCenter,
              child: RequesterBottomNav(active: 'home'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeroHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onFilterTap;

  const HomeHeroHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.onFilterTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool compact = screenWidth <= 390;

    final double imageHeight = compact ? 188 : 198;
    final double totalHeight = imageHeight + 36;
    final double subtitleSize = compact ? 12.5 : 13.2;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: imageHeight,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [navy, teal],
              ),
              boxShadow: [
                BoxShadow(
                  color: navy.withValues(alpha: 0.16),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/dashboard_bg.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          navy.withValues(alpha: 0.36),
                          navy.withValues(alpha: 0.72),
                          navy.withValues(alpha: 0.96),
                        ],
                      ),
                    ),
                  ),
                ),

                const Positioned(right: -30, top: -22, child: HeroPattern()),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 76),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: onProfileTap,
                            borderRadius: BorderRadius.circular(18),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/images/profile.png',
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.16,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const Spacer(),

                          Material(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: onNotificationTap,
                              customBorder: const CircleBorder(),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 21,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: AuthService.currentUserStream(),
                        builder: (context, snapshot) {
                          String firstName = 'User';

                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data();
                            final String fullName = data?['fullName'] ?? 'User';

                            firstName = fullName.trim().isEmpty
                                ? 'User'
                                : fullName.trim().split(' ').first;
                          }

                          return Text(
                            'Hello, $firstName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'What errand do you need today?',
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 14,
            right: 14,
            bottom: 0,
            child: Container(
              height: 58,
              padding: const EdgeInsets.only(left: 15, right: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: mutedText, size: 21),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Search errands, runners, services...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Material(
                    color: navy,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: onFilterTap,
                      borderRadius: BorderRadius.circular(15),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ),
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

class HeroPattern extends StatelessWidget {
  const HeroPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 120),
      painter: HeroPatternPainter(),
    );
  }
}

class HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final Paint dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.40),
      48,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.40),
      25,
      circlePaint,
    );

    final Path route = Path()
      ..moveTo(12, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.38,
        size.height * 0.20,
        size.width * 0.64,
        size.height * 0.52,
      )
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.72,
        size.width - 12,
        size.height * 0.36,
      );

    canvas.drawPath(route, linePaint);

    canvas.drawCircle(Offset(12, size.height * 0.78), 2.6, dotPaint);
    canvas.drawCircle(
      Offset(size.width * 0.64, size.height * 0.52),
      2.6,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width - 12, size.height * 0.36),
      2.6,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MainActionsCarousel extends StatelessWidget {
  const MainActionsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          DashboardActionCard(
            title: 'Post an Errand',
            subtitle:
                'Request help for food, laundry, parcels, school needs, and more.',
            badge: 'REQUESTER',
            actionText: 'Start now',
            icon: Icons.add_task_rounded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/servicehub');
            },
          ),
          const SizedBox(width: 12),
          DashboardActionCard(
            title: 'Track Status',
            subtitle: 'Follow accepted, in-progress, and delivered errands.',
            badge: 'TRACKING',
            actionText: 'Live',
            icon: Icons.route_rounded,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/activity');
            },
          ),
        ],
      ),
    );
  }
}

class DashboardActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String actionText;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.actionText,
    required this.icon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.of(context).size.width <= 390;
    final double cardWidth = compact ? 216 : 228;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [navy, teal],
            ),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -8,
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.10),
                  size: 92,
                ),
              ),

              const Positioned(right: 14, top: 14, child: ActionCardPattern()),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          actionText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 11,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCardPattern extends StatelessWidget {
  const ActionCardPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(64, 46),
      painter: ActionCardPatternPainter(),
    );
  }
}

class ActionCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(size.width * 0.32, size.height * 0.50), 22, paint);

    canvas.drawLine(
      Offset(size.width * 0.70, size.height * 0.20),
      Offset(size.width * 0.70, size.height * 0.78),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.52, size.height * 0.50),
      Offset(size.width * 0.88, size.height * 0.50),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Icons.chevron_right_rounded, color: navy, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceData> services = [
      ServiceData(icon: Icons.restaurant_rounded, label: 'Food'),
      ServiceData(icon: Icons.school_outlined, label: 'School'),
      ServiceData(icon: Icons.print_outlined, label: 'Printing'),
      ServiceData(icon: Icons.local_shipping_outlined, label: 'Parcel'),
      ServiceData(icon: Icons.local_laundry_service_outlined, label: 'Laundry'),
      ServiceData(icon: Icons.cleaning_services_outlined, label: 'Cleaning'),
      ServiceData(icon: Icons.menu_book_outlined, label: 'Tutoring'),
      ServiceData(icon: Icons.more_horiz_rounded, label: 'More'),
    ];

    return GridView.builder(
      itemCount: services.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 8,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        return ServiceGridItem(
          data: services[index],
          onTap: () {
            Navigator.pushReplacementNamed(context, '/servicehub');
          },
        );
      },
    );
  }
}

class ServiceData {
  final IconData icon;
  final String label;

  ServiceData({required this.icon, required this.label});
}

class ServiceGridItem extends StatelessWidget {
  final ServiceData data;
  final VoidCallback onTap;

  const ServiceGridItem({super.key, required this.data, required this.onTap});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: navy, size: 21),
          ),
          const SizedBox(height: 7),
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: mutedText,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveErrandCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String runner;
  final String status;
  final String eta;
  final double progress;

  const ActiveErrandCard({
    super.key,
    required this.icon,
    required this.title,
    required this.runner,
    required this.status,
    required this.eta,
    required this.progress,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: navy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: navy, size: 24),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          eta,
                          style: const TextStyle(
                            color: teal,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Runner: $runner',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: borderColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(navy),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      status,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActiveErrandsList extends StatelessWidget {
  const ActiveErrandsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ErrandService.requesterErrandsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _DashboardEmptyCard(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load errands',
            message: snapshot.error.toString(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final docs = snapshot.data!.docs.where((doc) {
          final status = (doc.data()['status'] ?? '').toString();
          return status != 'completed' && status != 'cancelled';
        }).toList();
        if (docs.isEmpty) {
          return const _DashboardEmptyCard(
            icon: Icons.assignment_outlined,
            title: 'No active errands yet',
            message:
                'Post an errand and it will appear here after it is created.',
          );
        }
        docs.sort((a, b) {
          final ta = a.data()['createdAt'];
          final tb = b.data()['createdAt'];
          if (ta is Timestamp && tb is Timestamp) return tb.compareTo(ta);
          return 0;
        });
        return Column(
          children: docs.take(3).map((doc) {
            final data = doc.data();
            final status = (data['status'] ?? 'pending').toString();
            final paid = (data['paymentStatus'] ?? 'unpaid').toString();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ActiveErrandCard(
                icon: Icons.local_shipping_outlined,
                title: (data['serviceType'] ?? 'Errand').toString(),
                runner: (data['runnerName'] ?? 'No runner selected').toString(),
                status: '$status • $paid',
                eta: (data['timeSlot'] ?? 'Waiting for update').toString(),
                progress: paid == 'paid' ? 0.55 : 0.25,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class RunnerList extends StatelessWidget {
  const RunnerList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: AuthService.runnersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _DashboardEmptyCard(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load runners',
            message: snapshot.error.toString(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final runners = snapshot.data!.docs
            .where((doc) => doc.id != AuthService.currentUserId)
            .toList();
        if (runners.isEmpty) {
          return const _DashboardEmptyCard(
            icon: Icons.person_search_rounded,
            title: 'No runners signed in yet',
            message:
                'Runner accounts will appear here only after they sign in and choose the Runner role.',
          );
        }
        runners.sort((a, b) {
          final ar = (a.data()['averageRating'] as num?)?.toDouble() ?? 0;
          final br = (b.data()['averageRating'] as num?)?.toDouble() ?? 0;
          return br.compareTo(ar);
        });
        return Column(
          children: runners.take(3).map((doc) {
            final data = doc.data();
            final rating = (data['averageRating'] as num?)?.toDouble() ?? 0.0;
            final ratingCount = (data['ratingCount'] as num?)?.toInt() ?? 0;
            final completed = (data['completedErrands'] as num?)?.toInt() ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RunnerTile(
                image: '',
                name: (data['fullName'] ?? data['email'] ?? 'Runner')
                    .toString(),
                location: data['isOnline'] == true ? 'Online now' : 'Offline',
                rating: ratingCount == 0
                    ? 'No rating'
                    : rating.toStringAsFixed(1),
                jobs: '$completed errands',
                tag: data['isVerified'] == true ? 'Verified' : 'Runner',
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DashboardEmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _DashboardEmptyCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFE6E9EF)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF003C56), size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF003C56),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF71787E),
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class RunnerTile extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final String rating;
  final String jobs;
  final String tag;

  const RunnerTile({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.jobs,
    required this.tag,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: navy.withValues(alpha: 0.10),
                      child: const Icon(Icons.person_rounded, color: navy),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag.toUpperCase(),
                      style: const TextStyle(
                        color: teal,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: mutedText,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: mutedText,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: teal, size: 15),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jobs,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: active == 'home',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.grid_view_rounded,
                activeIcon: Icons.grid_view_rounded,
                label: 'Services',
                isActive: active == 'services',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/servicehub');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'messages',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/messages');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
                label: 'Activity',
                isActive: active == 'activity',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/activity');
                },
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  static const Color navy = Color(0xFF003C56);
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.isActive || _isHovering;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        hoverColor: navy.withValues(alpha: 0.08),
        splashColor: navy.withValues(alpha: 0.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isActive
                ? navy
                : _isHovering
                ? navy.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                highlighted ? widget.activeIcon : widget.icon,
                color: widget.isActive ? Colors.white : navy,
                size: 21,
              ),
              const SizedBox(height: 5),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.isActive ? Colors.white : navy,
                  fontSize: 10,
                  fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

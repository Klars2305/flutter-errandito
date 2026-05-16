import 'package:flutter/material.dart';

class ExecutionStatusUpdatePage extends StatelessWidget {
  const ExecutionStatusUpdatePage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool narrowScreen = screenWidth <= 390;
    final double horizontalPadding = narrowScreen ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                112,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusHeader(
                        onBackTap: () {
                          Navigator.pushNamed(context, '/gig-finder');
                        },
                        onProfileTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),

                      const SizedBox(height: 18),

                      const CurrentErrandSummaryCard(),

                      const SizedBox(height: 18),

                      const StatusProgressCard(),

                      const SizedBox(height: 18),

                      const TaskRouteCard(),

                      const SizedBox(height: 18),

                      TaskActionCard(
                        onChatTap: () {
                          Navigator.pushNamed(context, '/execution-messaging');
                        },
                        onCompleteTap: () {
                          Navigator.pushNamed(
                            context,
                            '/task-complete-earnings',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Align(
              alignment: Alignment.bottomCenter,
              child: RunnerBottomNav(active: 'tasks'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onProfileTap;

  const StatusHeader({
    super.key,
    required this.onBackTap,
    required this.onProfileTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBackTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: navy,
                size: 18,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Task',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Update progress and complete the errand.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

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
                    color: navy.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: navy,
                    size: 23,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentErrandSummaryCard extends StatelessWidget {
  const CurrentErrandSummaryCard({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: navy.withOpacity(0.08),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: navy,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Courier Parcel Pickup',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Requester: Ella Cruz',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '₱90',
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    color: teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
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

class StatusProgressCard extends StatelessWidget {
  const StatusProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Task Progress',
            subtitle: 'Keep the requester updated as you complete the errand.',
          ),

          const SizedBox(height: 16),

          const StatusTimeline(),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Set On the Way',
                  icon: Icons.delivery_dining_rounded,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryActionButton(
                  label: 'Delivered',
                  icon: Icons.check_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/task-complete-earnings');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key});

  static const List<StatusStepData> steps = [
    StatusStepData(
      title: 'Accepted',
      subtitle: 'You accepted this errand.',
      isDone: true,
    ),
    StatusStepData(
      title: 'In Progress',
      subtitle: 'You are handling the task.',
      isDone: true,
    ),
    StatusStepData(
      title: 'On the Way',
      subtitle: 'Going to the drop-off location.',
      isDone: false,
    ),
    StatusStepData(
      title: 'Delivered',
      subtitle: 'Ready to complete the task.',
      isDone: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps
          .asMap()
          .entries
          .map(
            (entry) => StatusTimelineItem(
              step: entry.value,
              isLast: entry.key == steps.length - 1,
            ),
          )
          .toList(),
    );
  }
}

class StatusTimelineItem extends StatelessWidget {
  final StatusStepData step;
  final bool isLast;

  const StatusTimelineItem({
    super.key,
    required this.step,
    required this.isLast,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: step.isDone ? teal : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isDone ? teal : borderColor,
                  width: 1.4,
                ),
              ),
              child: Icon(
                step.isDone ? Icons.check_rounded : Icons.circle_outlined,
                color: step.isDone ? Colors.white : mutedText,
                size: step.isDone ? 16 : 12,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: step.isDone ? teal.withOpacity(0.35) : borderColor,
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: step.isDone ? navy : mutedText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: step.isDone ? teal : mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskRouteCard extends StatelessWidget {
  const TaskRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Route Details',
            subtitle: 'Confirm pickup and drop-off before completing.',
          ),
          SizedBox(height: 14),
          RouteInfoRow(
            icon: Icons.storefront_outlined,
            label: 'Pickup',
            value: 'JRS Panabo',
          ),
          SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Drop-off',
            value: 'DNSC Dormitory',
          ),
          SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.note_alt_outlined,
            label: 'Note',
            value: 'Bring valid ID. COD parcel already paid.',
          ),
        ],
      ),
    );
  }
}

class RouteInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const RouteInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: mutedText, size: 17),
        const SizedBox(width: 9),
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: const TextStyle(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class TaskActionCard extends StatelessWidget {
  final VoidCallback onChatTap;
  final VoidCallback onCompleteTap;

  const TaskActionCard({
    super.key,
    required this.onChatTap,
    required this.onCompleteTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Need to coordinate?',
            subtitle: 'Message the requester if pickup or delivery changes.',
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: navy, size: 19),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Use chat for substitutions, delays, or delivery confirmation.',
                    style: TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Open Chat',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: onChatTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryActionButton(
                  label: 'Complete',
                  icon: Icons.check_circle_outline_rounded,
                  onTap: onCompleteTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final Widget child;

  const StatusCard({super.key, required this.child});

  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, required this.subtitle});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            color: mutedText,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [navy, teal],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 17),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
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

class SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: navy, size: 17),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
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

class StatusStepData {
  final String title;
  final String subtitle;
  final bool isDone;

  const StatusStepData({
    required this.title,
    required this.subtitle,
    required this.isDone,
  });
}

class RunnerBottomNav extends StatelessWidget {
  final String active;

  const RunnerBottomNav({super.key, required this.active});

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
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: RunnerNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: active == 'home',
                onTap: () {
                  Navigator.pushNamed(context, '/runner-home');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Gigs',
                isActive: active == 'gigs',
                onTap: () {},
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: 'Tasks',
                isActive: active == 'tasks',
                onTap: () {
                  Navigator.pushNamed(context, '/execution-status');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'runner-messages',
                onTap: () {
                  Navigator.pushNamed(context, '/runner-messages');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const RunnerNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? navy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : inactive,
              size: 21,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive ? Colors.white : inactive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

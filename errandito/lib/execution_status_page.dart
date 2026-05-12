import 'package:flutter/material.dart';

class ExecutionStatusUpdatePage extends StatelessWidget {
  const ExecutionStatusUpdatePage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color textColor = Color(0xFF0D2C3A);
  static const Color teal = Color(0xFF005477);
  static const Color paleButton = Color(0xFFE7EDF3);
  static const Color borderColor = Color(0xFFD6E1E7);

  static const List<String> checklist = [
    'Picked fresh produce from market aisle 3',
    'Validated expiry dates for all dairy items',
    'Secured fragile goods with protective wrap',
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
                      Material(
                        color: paleButton,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pushNamed(context, '/gig-finder');
                          },
                          child: const SizedBox(
                            width: 34,
                            height: 34,
                            child: Center(
                              child: Text(
                                '←',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'Accepted Tasks',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      ClipOval(
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFE1E2E6),
                                child: const Icon(
                                  Icons.person,
                                  color: teal,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const StatusHeroCard(),

                  const SizedBox(height: 14),

                  StatusCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Update Task Status',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 12),
                        StatusProgressGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  StatusCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Picking Checklist',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...checklist.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '✓',
                                  style: TextStyle(
                                    color: teal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  StatusCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Message from Steward',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '"Organic spinach is unavailable. Shall I replace with kale?"',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ActionButton(
                                label: 'Open Chat',
                                isGhost: false,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/execution-messaging',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ActionButton(
                                label: 'Mark as Delivered',
                                isGhost: true,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/task-complete-earnings',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: RunnerBottomNav(active: 'tasks'),
          ),
        ],
      ),
    );
  }
}

class StatusHeroCard extends StatelessWidget {
  const StatusHeroCard({super.key});

  static const Color textColor = Color(0xFF0D2C3A);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'TASK STATUS',
            style: TextStyle(
              color: teal,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.96,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Accepted Errand',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Update task status, mark delivered, and complete the task.',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final Widget child;

  const StatusCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class StatusProgressGrid extends StatelessWidget {
  const StatusProgressGrid({super.key});

  static const List<_ProgressStep> steps = [
    _ProgressStep(label: 'Accepted', active: true),
    _ProgressStep(label: 'In Progress', active: true),
    _ProgressStep(label: 'On the Way', active: false),
    _ProgressStep(label: 'Delivered', active: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: ProgressStepBox(label: 'Accepted', active: true),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ProgressStepBox(label: 'In Progress', active: true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: ProgressStepBox(label: 'On the Way', active: false),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ProgressStepBox(label: 'Delivered', active: false),
            ),
          ],
        ),
      ],
    );
  }
}

class ProgressStepBox extends StatelessWidget {
  final String label;
  final bool active;

  const ProgressStepBox({
    super.key,
    required this.label,
    required this.active,
  });

  static const Color teal = Color(0xFF005477);
  static const Color textColor = Color(0xFF0D2C3A);
  static const Color borderColor = Color(0xFFD6E1E7);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? teal : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: active ? teal : borderColor,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: active ? Colors.white : textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final bool isGhost;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.isGhost,
    required this.onTap,
  });

  static const Color teal = Color(0xFF005477);
  static const Color textColor = Color(0xFF0D2C3A);
  static const Color paleButton = Color(0xFFE7EDF3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isGhost ? paleButton : teal,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isGhost ? textColor : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
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
            icon: Icons.assignment_outlined,
            label: 'Tasks',
            isActive: active == 'tasks',
            onTap: () {},
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

class _ProgressStep {
  final String label;
  final bool active;

  const _ProgressStep({
    required this.label,
    required this.active,
  });
}

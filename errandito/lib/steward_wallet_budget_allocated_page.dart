import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/auth_service.dart';

class StewardWalletBudgetAllocatedPage extends StatelessWidget {
  const StewardWalletBudgetAllocatedPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color panel = Color(0xFFF2F3F7);
  static const Color borderColor = Color(0xFFE6E9EF);

  double _moneyFrom(dynamic raw) {
    if (raw is num) return raw.toDouble();
    final clean = raw?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
    return double.tryParse(clean) ?? 0;
  }

  String _peso(double value) => '₱${value.toStringAsFixed(2)}';

  Map<String, dynamic> _statsFromErrands(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    double earnings = 0;
    int completed = 0;
    int active = 0;

    for (final doc in docs) {
      final data = doc.data();
      final status = (data['status'] ?? '').toString();
      final isCompleted = status == 'completed';
      final isActive = {
        'accepted',
        'in_progress',
        'on_the_way',
        'delivered',
      }.contains(status);

      if (isCompleted) {
        completed++;
        earnings += _moneyFrom(
          data['runnerPayout'] ?? data['runnerFee'] ?? data['budget'] ?? data['pay'],
        );
      }
      if (isActive) active++;
    }

    return {
      'earnings': earnings,
      'completed': completed,
      'active': active,
    };
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = AuthService.currentUserId;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: AuthService.currentUserStream(),
                    builder: (context, userSnapshot) {
                      final user = userSnapshot.data?.data() ?? <String, dynamic>{};
                      final name = (user['fullName'] ??
                              AuthService.currentUser?.displayName ??
                              AuthService.currentUser?.email?.split('@').first ??
                              'Runner')
                          .toString();
                      final email = (user['email'] ?? AuthService.currentUser?.email ?? '')
                          .toString();
                      final rating = user['averageRating'];
                      final ratingCount = user['ratingCount'];
                      final ratingText = rating is num && rating > 0
                          ? rating.toStringAsFixed(1)
                          : 'No ratings';
                      final ratingCountText = ratingCount is num
                          ? '${ratingCount.toInt()} review${ratingCount.toInt() == 1 ? '' : 's'}'
                          : '0 reviews';
                      final verified = user['isVerified'] == true;

                      if (uid == null) {
                        return const _ProfileMessage(
                          title: 'Please sign in',
                          message: 'Your runner profile will appear after signing in.',
                        );
                      }

                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('errands')
                            .where('runnerId', isEqualTo: uid)
                            .snapshots(),
                        builder: (context, errandSnapshot) {
                          final docs = errandSnapshot.data?.docs ?? [];
                          final stats = _statsFromErrands(docs);
                          final recentCompleted = docs.where((doc) {
                            return (doc.data()['status'] ?? '').toString() == 'completed';
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: navy.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      name.trim().isEmpty
                                          ? 'R'
                                          : name.trim()[0].toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 20,
                                        height: 2.25,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: navy,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          email,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: mutedText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Sign out',
                                    onPressed: () async {
                                      await AuthService.signOut();
                                      if (!context.mounted) return;
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/login',
                                        (route) => false,
                                      );
                                    },
                                    icon: const Icon(Icons.logout_rounded, color: navy),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Runner Profile',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your real earnings, ratings, active tasks, and account details.',
                                style: TextStyle(
                                  color: bodyText,
                                  fontSize: 14,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [navy, teal],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: navy.withOpacity(0.16),
                                      blurRadius: 30,
                                      offset: const Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            verified ? 'Verified Runner' : 'Runner Account',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.85),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.14),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            verified ? 'Verified' : 'Pending',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _peso(stats['earnings'] as double),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.6,
                                      ),
                                    ),
                                    Text(
                                      'Total completed-task earnings',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.78),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ProfileMetric(
                                            value: '${stats['completed']}',
                                            label: 'Completed',
                                            light: true,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _ProfileMetric(
                                            value: '${stats['active']}',
                                            label: 'Active',
                                            light: true,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _ProfileMetric(
                                            value: ratingText,
                                            label: 'Rating',
                                            light: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _InfoCard(
                                      icon: Icons.star_rounded,
                                      title: 'Rating',
                                      value: ratingText,
                                      subtitle: ratingCountText,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _InfoCard(
                                      icon: Icons.task_alt_rounded,
                                      title: 'Active Tasks',
                                      value: '${stats['active']}',
                                      subtitle: 'Currently assigned',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Reviews from requesters',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('reviews')
                                    .where('ratedUserId', isEqualTo: uid)
                                    .snapshots(),
                                builder: (context, reviewSnapshot) {
                                  if (reviewSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const _ProfilePanel(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final reviews =
                                      reviewSnapshot.data?.docs.toList() ?? [];

                                  reviews.sort((a, b) {
                                    final ta = a.data()['createdAt'];
                                    final tb = b.data()['createdAt'];
                                    if (ta is Timestamp && tb is Timestamp) {
                                      return tb.compareTo(ta);
                                    }
                                    return 0;
                                  });

                                  if (reviews.isEmpty) {
                                    return const _ProfileMessage(
                                      title: 'No reviews yet',
                                      message:
                                          'Requester reviews will appear here after completed errands.',
                                    );
                                  }

                                  return Column(
                                    children: reviews.take(5).map((doc) {
                                      final data = doc.data();
                                      final reviewer =
                                          (data['reviewerName'] ?? 'Requester')
                                              .toString();
                                      final rating =
                                          (data['rating'] as num?)?.toInt() ?? 0;
                                      final comment =
                                          (data['comment'] ?? '').toString();

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: _ReviewTile(
                                          reviewer: reviewer,
                                          rating: rating,
                                          comment: comment,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _ActionTile(
                                icon: Icons.receipt_long_rounded,
                                title: 'View active task',
                                subtitle: 'Open your current accepted errand.',
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/execution-status',
                                ),
                              ),
                              const SizedBox(height: 10),
                              _ActionTile(
                                icon: Icons.search_rounded,
                                title: 'Find gigs',
                                subtitle: 'Go back to available errands.',
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/gig-finder',
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Recent completed errands',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (errandSnapshot.connectionState ==
                                  ConnectionState.waiting)
                                const _ProfilePanel(
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              else if (recentCompleted.isEmpty)
                                const _ProfileMessage(
                                  title: 'No completed errands yet',
                                  message:
                                      'Completed errands and real earnings will appear here.',
                                )
                              else
                                ...recentCompleted.take(5).map((doc) {
                                  final data = doc.data();
                                  final title = (data['serviceType'] ??
                                          data['title'] ??
                                          'Errand')
                                      .toString();
                                  final requester = (data['requesterName'] ??
                                          'Requester')
                                      .toString();
                                  final pay = _moneyFrom(data['runnerPayout'] ??
                                      data['runnerFee'] ??
                                      data['budget'] ??
                                      data['pay']);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _CompletedTile(
                                      title: title,
                                      subtitle: requester,
                                      amount: _peso(pay),
                                    ),
                                  );
                                }),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
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

class _ReviewTile extends StatelessWidget {
  final String reviewer;
  final int rating;
  final String comment;

  const _ReviewTile({
    required this.reviewer,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfilePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reviewer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF003C56),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: const Color(0xFF005477),
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          if (comment.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              comment,
              style: const TextStyle(
                color: Color(0xFF40484E),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  final Widget child;

  const _ProfilePanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E9EF)),
      ),
      child: child,
    );
  }
}

class _ProfileMessage extends StatelessWidget {
  final String title;
  final String message;

  const _ProfileMessage({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return _ProfilePanel(
      child: Column(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF003C56), size: 34),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF003C56),
              fontSize: 16,
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
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String value;
  final String label;
  final bool light;

  const _ProfileMetric({required this.value, required this.label, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light ? Colors.white.withOpacity(0.12) : const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: light ? Colors.white : const Color(0xFF003C56),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: light ? Colors.white.withOpacity(0.76) : const Color(0xFF71787E),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfilePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF005477), size: 22),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF71787E),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF003C56),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF71787E),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hovered ? const Color(0xFFEAF3F6) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE6E9EF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003C56).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: const Color(0xFF003C56)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Color(0xFF003C56),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF71787E),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, color: Color(0xFF005477)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletedTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const _CompletedTile({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfilePanel(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.check_circle_rounded, color: Color(0xFF005477)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF003C56),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF71787E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF003C56),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
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
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Gigs',
                isActive: active == 'gigs',
                onTap: () => Navigator.pushReplacementNamed(context, '/gig-finder'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: 'Tasks',
                isActive: active == 'tasks',
                onTap: () => Navigator.pushReplacementNamed(context, '/execution-status'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'messages',
                onTap: () => Navigator.pushReplacementNamed(context, '/runner-messages'),
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () => Navigator.pushReplacementNamed(context, '/runner-profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerNavItem extends StatefulWidget {
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

  @override
  State<RunnerNavItem> createState() => _RunnerNavItemState();
}

class _RunnerNavItemState extends State<RunnerNavItem> {
  bool hovered = false;
  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final activeOrHover = widget.isActive || hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isActive
                ? navy
                : hovered
                    ? const Color(0xFFEAF3F6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                activeOrHover ? widget.activeIcon : widget.icon,
                color: widget.isActive ? Colors.white : (hovered ? navy : inactive),
                size: 21,
              ),
              const SizedBox(height: 5),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.isActive ? Colors.white : (hovered ? navy : inactive),
                  fontSize: 10,
                  fontWeight: activeOrHover ? FontWeight.w800 : FontWeight.w600,
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

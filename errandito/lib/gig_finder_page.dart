import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'services/errand_service.dart';
import 'services/auth_service.dart';

class GigFinderJobListingsPage extends StatefulWidget {
  const GigFinderJobListingsPage({super.key});

  @override
  State<GigFinderJobListingsPage> createState() =>
      _GigFinderJobListingsPageState();
}

class _GigFinderJobListingsPageState extends State<GigFinderJobListingsPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();

  static const Color background = Color(0xFFF8F9FD);

  final List<GigItem> sampleGigs = const [];

  List<GigItem> _filterGigs(List<GigItem> source) {
    final String query = searchQuery.trim().toLowerCase();

    return source.where((gig) {
      final bool matchesCategory =
          selectedCategory == 'All' || gig.filter == selectedCategory;

      final bool matchesSearch =
          query.isEmpty ||
          gig.title.toLowerCase().contains(query) ||
          gig.category.toLowerCase().contains(query) ||
          gig.filter.toLowerCase().contains(query) ||
          gig.requester.toLowerCase().contains(query) ||
          gig.pickup.toLowerCase().contains(query) ||
          gig.dropoff.toLowerCase().contains(query) ||
          gig.time.toLowerCase().contains(query) ||
          gig.pay.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<GigItem> _fromErrandDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final String? runnerId = AuthService.currentUserId;

    return docs
        .where((doc) {
          final data = doc.data();
          final String status = (data['status'] ?? '').toString();
          final String paymentStatus = (data['paymentStatus'] ?? '').toString();
          final String? assignedRunnerId = data['runnerId']?.toString();

          final String paymentMethod = (data['paymentMethod'] ?? '').toString();

          final bool isPaymentConfirmed =
              paymentStatus == 'paid' ||
              (paymentMethod == 'cod' && paymentStatus == 'cod_pending');
          final bool isPaidVisible =
              isPaymentConfirmed &&
              (status == 'paid' ||
                  status == 'paid_waiting_runner' ||
                  status == 'booked_paid' ||
                  status == 'posted' ||
                  status == 'pending_payment');
          final bool isForThisRunner =
              assignedRunnerId == null ||
              assignedRunnerId.isEmpty ||
              assignedRunnerId == runnerId;

          return isPaidVisible && isForThisRunner;
        })
        .map((doc) => GigItem.fromFirestore(doc))
        .toList();
  }

  void showRunnerNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6E9EF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Runner Notifications',
                  style: TextStyle(
                    color: Color(0xFF003C56),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: ErrandService.currentUserNotificationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          'No new booking notifications yet.',
                          style: TextStyle(
                            color: Color(0xFF71787E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data();
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE6E9EF)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003C56),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.notifications_active_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data['title'] ?? 'You got booked')
                                          .toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF003C56),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      (data['body'] ?? '').toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF40484E),
                                        fontSize: 12,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      searchQuery = '';
    });
  }

  void showFilterInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E9EF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter Errands',
                    style: TextStyle(
                      color: Color(0xFF003C56),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Use the category chips and search bar to find errands by service, location, requester, time, or pay.',
                    style: TextStyle(
                      color: Color(0xFF71787E),
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFF003C56),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text(
                            'Got it',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
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
        );
      },
    );
  }

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
                      RunnerHeader(
                        onProfileTap: () {
                          Navigator.pushReplacementNamed(context, '/runner-profile');
                        },
                        onNotificationTap: showRunnerNotifications,
                      ),

                      const SizedBox(height: 18),

                      const RunnerHeroSummary(),

                      const SizedBox(height: 24),

                      SectionTitle(
                        title: 'Available Errands',
                        subtitle: 'Accept tasks that fit your route and time.',
                        onFilterTap: showFilterInfo,
                      ),

                      const SizedBox(height: 12),

                      GigSearchBar(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        onClear: clearSearch,
                      ),

                      const SizedBox(height: 14),

                      GigCategoryChips(
                        selectedCategory: selectedCategory,
                        onChanged: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: ErrandService.openErrandsStream(),
                        builder: (context, snapshot) {
                          final List<GigItem> allGigs = snapshot.hasData
                              ? _fromErrandDocs(snapshot.data!.docs)
                              : <GigItem>[];

                          if (snapshot.hasError) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Could not load live errands: ${snapshot.error}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                EmptyGigState(
                                  selectedCategory: selectedCategory,
                                  searchQuery: searchQuery,
                                ),
                              ],
                            );
                          }

                          return GigList(
                            gigs: _filterGigs(allGigs),
                            selectedCategory: selectedCategory,
                            searchQuery: searchQuery,
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
              child: RunnerBottomNav(active: 'gigs'),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;

  const RunnerHeader({
    super.key,
    required this.onProfileTap,
    required this.onNotificationTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: AuthService.currentUserStream(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};
        final name = (data['fullName'] ??
                AuthService.currentUser?.displayName ??
                AuthService.currentUser?.email?.split('@').first ??
                'Runner')
            .toString();
        final email = (data['email'] ?? AuthService.currentUser?.email ?? '')
            .toString();
        final initial = name.trim().isEmpty ? 'R' : name.trim()[0].toUpperCase();
        final verified = data['isVerified'] == true;

        return Row(
          children: [
            InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email.isEmpty ? 'Find errands and earn today.' : email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: teal.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded, color: teal, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    verified ? 'Verified' : 'Runner',
                    style: const TextStyle(
                      color: teal,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onNotificationTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: navy,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RunnerHeroSummary extends StatelessWidget {
  const RunnerHeroSummary({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  double _moneyFrom(dynamic raw) {
    if (raw is num) return raw.toDouble();
    final clean = raw?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
    return double.tryParse(clean) ?? 0;
  }

  String _peso(double value) => '₱${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final uid = AuthService.currentUserId;
    if (uid == null) {
      return _summaryCard(
        earnings: '₱0.00',
        completed: '0',
        open: '0',
        rating: '—',
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('errands').snapshots(),
      builder: (context, errandSnapshot) {
        final allDocs = errandSnapshot.data?.docs ?? [];
        double earnings = 0;
        int completed = 0;
        int open = 0;

        for (final doc in allDocs) {
          final data = doc.data();
          final status = (data['status'] ?? '').toString();
          final runnerId = data['runnerId']?.toString();
          final visible = data['visibleToRunners'] == true;
          final paymentStatus = (data['paymentStatus'] ?? '').toString();

          if (runnerId == uid && status == 'completed') {
            completed++;
            earnings += _moneyFrom(
              data['runnerPayout'] ?? data['runnerFee'] ?? data['budget'] ?? data['pay'],
            );
          }

          if (visible == true && paymentStatus == 'paid') {
            final assignedRunnerId = data['runnerId']?.toString();
            if (assignedRunnerId == null || assignedRunnerId.isEmpty || assignedRunnerId == uid) {
              open++;
            }
          }
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: AuthService.currentUserStream(),
          builder: (context, userSnapshot) {
            final user = userSnapshot.data?.data() ?? <String, dynamic>{};
            final ratingRaw = user['averageRating'];
            final rating = ratingRaw is num && ratingRaw > 0
                ? ratingRaw.toStringAsFixed(1)
                : '—';

            return _summaryCard(
              earnings: _peso(earnings),
              completed: '$completed',
              open: '$open',
              rating: rating,
            );
          },
        );
      },
    );
  }

  Widget _summaryCard({
    required String earnings,
    required String completed,
    required String open,
    required String rating,
  }) {
    return Container(
      width: double.infinity,
      height: 154,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, teal],
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.14),
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
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    navy.withOpacity(0.96),
                    navy.withOpacity(0.82),
                    teal.withOpacity(0.58),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.delivery_dining_rounded,
              color: Colors.white.withOpacity(0.12),
              size: 118,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Completed Earnings',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  earnings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: SummaryMetric(value: completed, label: 'Done')),
                    Expanded(child: SummaryMetric(value: open, label: 'Open')),
                    Expanded(child: SummaryMetric(value: rating, label: 'Rating')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const SummaryMetric({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.74),
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onFilterTap;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onFilterTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
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
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onFilterTap,
          tooltip: 'Filter errands',
          icon: const Icon(Icons.tune_rounded, color: navy, size: 21),
        ),
      ],
    );
  }
}

class GigSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const GigSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 14, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: mutedText, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                color: navy,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Search errands, locations, or pay...',
                hintStyle: TextStyle(
                  color: mutedText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, color: mutedText, size: 19),
            ),
        ],
      ),
    );
  }
}

class GigCategoryChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const GigCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  static const List<String> categories = [
    'All',
    'Food',
    'School',
    'Printing',
    'Parcel',
    'Laundry',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String category = categories[index];

          return GigCategoryChip(
            label: category,
            isActive: selectedCategory == category,
            onTap: () {
              onChanged(category);
            },
          );
        },
      ),
    );
  }
}

class GigCategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const GigCategoryChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? navy : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: isActive ? navy : borderColor),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class GigList extends StatelessWidget {
  final List<GigItem> gigs;
  final String selectedCategory;
  final String searchQuery;

  const GigList({
    super.key,
    required this.gigs,
    required this.selectedCategory,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (gigs.isEmpty) {
      return EmptyGigState(
        selectedCategory: selectedCategory,
        searchQuery: searchQuery,
      );
    }

    return Column(
      children: gigs
          .map(
            (gig) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GigCard(gig: gig),
            ),
          )
          .toList(),
    );
  }
}

class EmptyGigState extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;

  const EmptyGigState({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    final bool hasSearch = searchQuery.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, color: navy, size: 34),
          const SizedBox(height: 10),
          const Text(
            'No errands found',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasSearch
                ? 'No result for "$searchQuery" in $selectedCategory.'
                : 'Try choosing another category.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class GigCard extends StatelessWidget {
  final GigItem gig;

  const GigCard({super.key, required this.gig});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/grocery-pickup-details',
            arguments: gig.errandId,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: navy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(gig.icon, color: navy, size: 24),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gig.category.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: teal,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          gig.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Requester: ${gig.requester}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        gig.pay,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: teal.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          gig.fromRequesterPost ? 'LIVE' : 'Open',
                          style: const TextStyle(
                            color: teal,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 13),

              GigInfoRow(
                icon: Icons.storefront_outlined,
                label: 'Pickup',
                value: gig.pickup,
              ),

              const SizedBox(height: 7),

              GigInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Drop-off',
                value: gig.dropoff,
              ),

              const SizedBox(height: 7),

              GigInfoRow(
                icon: Icons.schedule_rounded,
                label: 'Time',
                value: gig.time,
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  Expanded(
                    child: SecondaryActionButton(
                      label: 'Details',
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Navigator.pushNamed(
            context,
            '/grocery-pickup-details',
            arguments: gig.errandId,
          );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Accept',
                      icon: Icons.check_rounded,
                      onTap: () async {
                        if (gig.errandId != null) {
                          try {
                            await ErrandService.acceptErrand(
                              errandId: gig.errandId!,
                            );

                            final serviceEnabled =
                                await Geolocator.isLocationServiceEnabled();
                            if (serviceEnabled) {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                              }

                              if (permission != LocationPermission.denied &&
                                  permission !=
                                      LocationPermission.deniedForever) {
                                final position =
                                    await Geolocator.getCurrentPosition(
                                      locationSettings: const LocationSettings(
                                        accuracy: LocationAccuracy.high,
                                      ),
                                    );

                                await ErrandService.updateRunnerLocation(
                                  errandId: gig.errandId!,
                                  lat: position.latitude,
                                  lng: position.longitude,
                                );
                              }
                            }

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Errand accepted. Requester has been notified.',
                                ),
                              ),
                            );
                            Navigator.pushNamed(
                              context,
                              '/execution-status',
                              arguments: gig.errandId!,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to accept errand: $e'),
                              ),
                            );
                          }
                        } else {
                          Navigator.pushReplacementNamed(context, '/execution-status');
                        }
                      },
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

class GigInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const GigInfoRow({
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
        Icon(icon, color: mutedText, size: 15),
        const SizedBox(width: 7),
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: const TextStyle(
              color: mutedText,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
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

class GigItem {
  final IconData icon;
  final String filter;
  final String category;
  final String title;
  final String requester;
  final String pickup;
  final String dropoff;
  final String time;
  final String pay;
  final String? errandId;
  final bool fromRequesterPost;

  const GigItem({
    required this.icon,
    required this.filter,
    required this.category,
    required this.title,
    required this.requester,
    required this.pickup,
    required this.dropoff,
    required this.time,
    required this.pay,
    this.errandId,
    this.fromRequesterPost = false,
  });

  factory GigItem.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data();
    return GigItem(
      icon: Icons.local_shipping_outlined,
      filter: (data['filter'] ?? 'Grocery').toString(),
      category: (data['category'] ?? data['serviceType'] ?? 'Posted Errand')
          .toString(),
      title: (data['title'] ?? data['serviceType'] ?? 'Requester Errand')
          .toString(),
      requester: (data['requesterName'] ?? 'Requester').toString(),
      pickup: (data['pickup'] ?? data['serviceAddress'] ?? 'Panabo City')
          .toString(),
      dropoff: (data['dropoff'] ?? data['serviceAddress'] ?? 'Panabo City')
          .toString(),
      time: (data['timeSlot'] ?? data['preferredDate'] ?? 'ASAP').toString(),
      pay: (data['pay'] ?? data['budget'] ?? '₱120').toString(),
      errandId: doc.id,
      fromRequesterPost: true,
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
                isActive: active == 'messages' || active == 'runner-messages',
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
    final bool activeOrHover = widget.isActive || hovered;
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


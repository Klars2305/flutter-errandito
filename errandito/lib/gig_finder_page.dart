import 'package:flutter/material.dart';

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
  static const Color navy = Color(0xFF003C56);

  final List<GigItem> gigs = const [
    GigItem(
      icon: Icons.restaurant_rounded,
      filter: 'Food',
      category: 'Food / Pasabuy',
      title: 'Meal Pickup',
      requester: 'Mia Santos',
      pickup: 'Jollibee Panabo',
      dropoff: 'Boarding House Area',
      time: 'ASAP',
      pay: '₱75',
    ),
    GigItem(
      icon: Icons.school_outlined,
      filter: 'School',
      category: 'School Supplies',
      title: 'Buy School Supplies',
      requester: 'Ralph Dela Cruz',
      pickup: 'Nearest Bookstore',
      dropoff: 'Panabo Campus',
      time: 'Before 4:00 PM',
      pay: '₱55',
    ),
    GigItem(
      icon: Icons.print_outlined,
      filter: 'Printing',
      category: 'Printing / Documents',
      title: 'Print Project Files',
      requester: 'John Reyes',
      pickup: 'PrintHub Panabo',
      dropoff: 'Panabo Campus Gate',
      time: 'Today, 1:45 PM',
      pay: '₱60',
    ),
    GigItem(
      icon: Icons.local_shipping_outlined,
      filter: 'Parcel',
      category: 'Parcel Pickup',
      title: 'Courier Parcel Pickup',
      requester: 'Ella Cruz',
      pickup: 'JRS Panabo',
      dropoff: 'DNSC Dormitory',
      time: 'Today, 2:30 PM',
      pay: '₱90',
    ),
    GigItem(
      icon: Icons.local_laundry_service_outlined,
      filter: 'Laundry',
      category: 'Laundry Pickup',
      title: 'Laundry Pickup and Return',
      requester: 'Ana Corpuz',
      pickup: 'Panabo City Center',
      dropoff: 'Laundry Hub',
      time: 'Before 5:00 PM',
      pay: '₱80',
    ),
  ];

  List<GigItem> get filteredGigs {
    final String query = searchQuery.trim().toLowerCase();

    return gigs.where((gig) {
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
                          Navigator.pushNamed(context, '/profile');
                        },
                        onNotificationTap: () {},
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

                      GigList(
                        gigs: filteredGigs,
                        selectedCategory: selectedCategory,
                        searchQuery: searchQuery,
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
    return Row(
      children: [
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/profile.png',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: navy,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Runner',
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
                'Find errands and earn today.',
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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: teal.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: teal, size: 14),
              SizedBox(width: 4),
              Text(
                'Verified',
                style: TextStyle(
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
  }
}

class RunnerHeroSummary extends StatelessWidget {
  const RunnerHeroSummary({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
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
                  'Today’s Earnings',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.80),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  '₱420.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),

                const Spacer(),

                const Row(
                  children: [
                    Expanded(
                      child: SummaryMetric(value: '3', label: 'Done'),
                    ),
                    Expanded(
                      child: SummaryMetric(value: '12', label: 'Open'),
                    ),
                    Expanded(
                      child: SummaryMetric(value: '4.9', label: 'Rating'),
                    ),
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
            color: Colors.white.withOpacity(0.74),
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
          Navigator.pushNamed(context, '/grocery-pickup-details');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.08),
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
                          color: teal.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Open',
                          style: TextStyle(
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
                        Navigator.pushNamed(context, '/grocery-pickup-details');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryActionButton(
                      label: 'Accept',
                      icon: Icons.check_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/execution-status');
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
                isActive: active == 'messages',
                onTap: () {
                  Navigator.pushNamed(context, '/execution-messaging');
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

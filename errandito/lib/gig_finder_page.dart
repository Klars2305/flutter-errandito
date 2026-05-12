import 'package:flutter/material.dart';

class GigFinderJobListingsPage extends StatelessWidget {
  const GigFinderJobListingsPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color grayText = Color(0xFF536167);
  static const Color mutedText = Color(0xFF71787E);

  static const List<String> categories = [
    'All Tasks',
    'Food / Pasabuy',
    'School Supplies',
    'Printing / Documents',
    'Parcel Pickup / Drop-off',
    'Laundry Pickup',
  ];

  static const List<GigItem> gigs = [
    GigItem(
      image: 'assets/images/grocery.png',
      label: 'Food / Pasabuy',
      title: 'Pasabuy Meal Pickup',
      pay: '₱45.00',
      metaA: 'Panabo City Proper',
      metaB: 'Starts 2:00 PM',
      action: 'Accept Errand',
    ),
    GigItem(
      image: 'assets/images/admin.png',
      label: 'School Supplies',
      title: 'Notebook and pens purchase',
      pay: '₱32.50',
      metaA: 'Near DNSC',
      metaB: 'Rush item',
      action: 'Accept Errand',
    ),
    GigItem(
      image: 'assets/images/parcel.png',
      label: 'Printing / Documents',
      title: 'Print and deliver project documents',
      pay: '₱60.00',
      metaA: 'Panabo Hall Area',
      metaB: '20 pages',
      action: 'Accept Errand',
    ),
    GigItem(
      image: 'assets/images/parcel.png',
      label: 'Parcel Pickup / Drop-off',
      title: 'Pick up parcel and drop at dorm',
      pay: '₱85.00',
      metaA: 'JRS Panabo',
      metaB: 'COD parcel',
      action: 'Accept Errand',
      description:
          'Handle pickup at courier branch and drop-off at requested location.',
    ),
    GigItem(
      image: 'assets/images/logistics.png',
      label: 'Laundry Pickup',
      title: 'Laundry pickup and return',
      pay: '₱60.00',
      metaA: 'Panabo City Center',
      metaB: 'Pickup before 4 PM',
      action: 'Accept Errand',
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
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
                          const SizedBox(width: 12),
                          const Text(
                            'Hi, Bronny',
                            style: TextStyle(
                              color: navy,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Errands Marketplace',
                            style: TextStyle(
                              color: navy,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              height: 1.11,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'View details and accept available errands.',
                            style: TextStyle(
                              color: grayText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: null,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7E7FF).withOpacity(0.30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Panabo City, Davao del Norte',
                              style: TextStyle(
                                color: navy,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: darkText.withOpacity(0.06),
                                        blurRadius: 48,
                                        offset: const Offset(0, 24),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search tasks, locations, or categories...',
                                      hintStyle: const TextStyle(
                                        color: mutedText,
                                        fontSize: 14,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Material(
                                color: navy,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 17,
                                    ),
                                    child: Text(
                                      'Filters',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categories.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final String category = entry.value;
                                final bool isActive = index == 0;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? navy
                                          : const Color(0xFFF2F3F7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: isActive
                                              ? Colors.white
                                              : grayText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Column(
                            children: gigs
                                .map(
                                  (gig) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: GigCard(gig: gig),
                                  ),
                                )
                                .toList(),
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
            child: RunnerBottomNav(active: 'gigs'),
          ),
        ],
      ),
    );
  }
}

class GigCard extends StatelessWidget {
  final GigItem gig;

  const GigCard({
    super.key,
    required this.gig,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color grayText = Color(0xFF536167);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: darkText.withOpacity(0.04),
            blurRadius: 48,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  gig.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFECEEF1),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: navy,
                          size: 56,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 14,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E5EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      gig.label.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF58676D),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        gig.title,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          gig.pay,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.23,
                          ),
                        ),
                        const Text(
                          'Est. Pay',
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (gig.description != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    gig.description!,
                    style: const TextStyle(
                      color: grayText,
                      fontSize: 14,
                      height: 1.57,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    Text(
                      gig.metaA,
                      style: const TextStyle(
                        color: grayText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (gig.metaB != null)
                      Text(
                        gig.metaB!,
                        style: const TextStyle(
                          color: grayText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          navy,
                          teal,
                        ],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/grocery-pickup-details',
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            gig.action,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
        ],
      ),
    );
  }
}

class GigItem {
  final String image;
  final String label;
  final String title;
  final String pay;
  final String metaA;
  final String? metaB;
  final String action;
  final String? description;

  const GigItem({
    required this.image,
    required this.label,
    required this.title,
    required this.pay,
    required this.metaA,
    this.metaB,
    required this.action,
    this.description,
  });
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
            label: 'Gigs',
            isActive: active == 'gigs',
            onTap: () {},
          ),
          BottomNavItem(
            icon: Icons.assignment_outlined,
            label: 'Status',
            isActive: active == 'status',
            onTap: () {
              Navigator.pushNamed(context, '/execution-status');
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

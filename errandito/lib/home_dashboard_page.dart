import 'package:flutter/material.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color green = Color(0xFF004035);
  static const Color darkGreen = Color(0xFF17584C);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color lightCyan = Color(0xFF67E8F9);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF536167);
  static const Color softText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width <= 390;

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
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isSmall ? 16 : 24,
                    16,
                    isSmall ? 16 : 24,
                    132,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, Bronny.',
                            style: TextStyle(
                              color: navy,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              height: 1.11,
                              letterSpacing: -0.9,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Home dashboard for your errands.',
                            style: TextStyle(
                              color: mutedText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
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
                              children: const [
                                RecentErrandsHeader(),
                                SizedBox(height: 16),
                                RecentErrandParcel(),
                                SizedBox(height: 8),
                                RecentErrandPrinting(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  label: 'TIME SAVED',
                                  value: '12.4 hrs',
                                  note: 'This month so far',
                                  isDark: false,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: StatCard(
                                  label: 'STREAK',
                                  value: '8 Days',
                                  note: 'Effortless living',
                                  isDark: true,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -64,
                                  top: -64,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      color: teal.withOpacity(0.50),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: cyan,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Categories',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    SmartCategoryCard(
                                      kicker: 'Food / Pasabuy',
                                      time: 'Most requested',
                                      name: 'Meals and quick pasabuy',
                                      text:
                                          'Buy food, snacks, and small items — pickup and deliver to your preferred location.',
                                      isGlass: true,
                                      showButton: true,
                                    ),
                                    SizedBox(height: 12),
                                    SmartCategoryCard(
                                      kicker: 'School Supplies',
                                      time: 'Common',
                                      name: 'Notebooks and essentials',
                                      text:
                                          'Purchase school items near campus and deliver them to you.',
                                      isGlass: false,
                                      showButton: false,
                                    ),
                                    SizedBox(height: 12),
                                    ServiceMapCard(),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available Runners',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      height: 1.33,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Top rated runners near you',
                                    style: TextStyle(
                                      color: mutedText,
                                      fontSize: 14,
                                      height: 1.42,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                iconAlignment: IconAlignment.end,
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: navy,
                                  size: 16,
                                ),
                                label: const Text(
                                  'View All',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.78,
                            children: const [
                              RunnerCard(
                                image: 'assets/images/helper.png',
                                kicker: 'Verified Runner',
                                title: 'Christian\nMisal',
                                meta: '4.9 • 340 errands',
                              ),
                              RunnerCard(
                                image: 'assets/images/helper_female.png',
                                kicker: 'Verified Runner',
                                title: 'Jerlyn\nCorpuz',
                                meta: '4.8 • 210 errands',
                              ),
                              RunnerCard(
                                image: 'assets/images/steward.png',
                                kicker: 'Top Rated',
                                title: 'Klarence\nDegracia',
                                meta: '5.0 • 94 errands',
                              ),
                              RunnerCard(
                                image: 'assets/images/profile.png',
                                kicker: 'Nearby',
                                title: 'Jamaica\nMasinapoc',
                                meta: '4.9 • 128 errands',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            right: 24,
            bottom: 262,
            child: Material(
              color: navy,
              borderRadius: BorderRadius.circular(16),
              elevation: 10,
              shadowColor: navy.withOpacity(0.20),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pushNamed(context, '/servicehub');
                },
                child: const SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
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
    );
  }
}

class RecentErrandsHeader extends StatelessWidget {
  const RecentErrandsHeader({super.key});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Errands',
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFC7E7FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '2 IN-PROGRESS',
            style: TextStyle(
              color: Color(0xFF001E2E),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class RecentErrandParcel extends StatelessWidget {
  const RecentErrandParcel({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF536167);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFD6E5EC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: navy,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parcel Pickup / Drop-off',
                            style: TextStyle(
                              color: Color(0xFF191C1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Assigned to: Christian Misal',
                            style: TextStyle(
                              color: mutedText,
                              fontSize: 14,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'ETA: 14:30',
                      style: TextStyle(
                        color: navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 6,
                    color: const Color(0xFFE1E2E6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.65,
                        child: Container(color: navy),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PICKED UP',
                      style: TextStyle(
                        color: Color(0xFFD6E5EC),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.22,
                      ),
                    ),
                    Text(
                      'EN ROUTE',
                      style: TextStyle(
                        color: navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.22,
                      ),
                    ),
                    Text(
                      'COMPLETE',
                      style: TextStyle(
                        color: Color(0xFFC0C7CE),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.22,
                      ),
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

class RecentErrandPrinting extends StatelessWidget {
  const RecentErrandPrinting({super.key});

  static const Color green = Color(0xFF004035);
  static const Color mutedText = Color(0xFF536167);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFB1EFDE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shopping_basket,
              color: green,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Printing / Documents',
                            style: TextStyle(
                              color: Color(0xFF191C1E),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.55,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '20 pages • Pickup at print shop',
                            style: TextStyle(
                              color: mutedText,
                              fontSize: 14,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'In Progress',
                      style: TextStyle(
                        color: green,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: MiniProgressBar(isActive: true)),
                    SizedBox(width: 8),
                    Expanded(child: MiniProgressBar(isActive: true)),
                    SizedBox(width: 8),
                    Expanded(child: MiniProgressBar(isActive: false)),
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

class MiniProgressBar extends StatelessWidget {
  final bool isActive;

  const MiniProgressBar({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF004035) : const Color(0xFFE1E2E6),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final bool isDark;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF17584C) : const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? const Color(0xFF8FCCBC) : const Color(0xFF536167),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF003C56),
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: TextStyle(
              color: isDark ? const Color(0xFF8FCCBC) : const Color(0xFF40484E),
              fontSize: 12,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}

class SmartCategoryCard extends StatelessWidget {
  final String kicker;
  final String time;
  final String name;
  final String text;
  final bool isGlass;
  final bool showButton;

  const SmartCategoryCard({
    super.key,
    required this.kicker,
    required this.time,
    required this.name,
    required this.text,
    required this.isGlass,
    required this.showButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isGlass ? 0.10 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: isGlass
            ? Border.all(color: Colors.white.withOpacity(0.05))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kicker.toUpperCase(),
                  style: TextStyle(
                    color: isGlass
                        ? const Color(0xFF67E8F9)
                        : Colors.white.withOpacity(0.60),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: isGlass
                      ? Colors.white.withOpacity(0.60)
                      : Colors.white.withOpacity(0.40),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.42,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(isGlass ? 0.80 : 0.70),
              fontSize: 12,
              height: 1.625,
            ),
          ),
          if (showButton) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF003C56),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Post in this category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ServiceMapCard extends StatelessWidget {
  const ServiceMapCard({super.key});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/service_map.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.white.withOpacity(0.08),
                child: const Icon(
                  Icons.map_outlined,
                  color: Colors.white70,
                  size: 48,
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  navy.withOpacity(0.80),
                  navy.withOpacity(0.0),
                ],
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Runners nearby in Panabo City',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RunnerCard extends StatelessWidget {
  final String image;
  final String kicker;
  final String title;
  final String meta;

  const RunnerCard({
    super.key,
    required this.image,
    required this.kicker,
    required this.title,
    required this.meta,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color cyan = Color(0xFF22D3EE);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 204,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: navy,
                child: const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 48,
                ),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  navy.withOpacity(0.90),
                  navy.withOpacity(0.20),
                  navy.withOpacity(0.0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker.toUpperCase(),
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  meta,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.60),
                    fontSize: 12,
                    height: 1.33,
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

class RequesterBottomNav extends StatelessWidget {
  final String active;

  const RequesterBottomNav({
    super.key,
    required this.active,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 97,
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.80),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
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
              onTap: () {},
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
              icon: Icons.receipt_long_outlined,
              label: 'Activity',
              isActive: active == 'activity',
              onTap: () {
                Navigator.pushNamed(context, '/activity');
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
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : inactive,
                  size: 22,
                ),
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

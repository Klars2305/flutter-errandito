import 'package:flutter/material.dart';

class GroceryPickupDetailsPage extends StatelessWidget {
  const GroceryPickupDetailsPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color skyNavy = Color(0xFF0C4A6E);
  static const Color green = Color(0xFF004035);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);

  static const List<LogisticsStop> logistics = [
    LogisticsStop(
      type: 'Pickup',
      title: 'Whole Foods Market',
      address: 'Columbus Circle, NY 10019',
      contact: 'Contact: Concierge Desk',
      tone: LogisticsTone.pickup,
    ),
    LogisticsStop(
      type: 'Drop-off',
      title: '15 CPW Residences',
      address: '15 Central Park West, NY 10023',
      contact: 'Contact: Service Entrance',
      tone: LogisticsTone.dropoff,
    ),
  ];

  static const List<String> mandates = [
    'Ensure all produce is hand-picked for perfection.',
    'Cold items must remain in insulated bags throughout transit.',
    'Use provided digital checklist for all items.',
    'Photo of receipt required for reimbursement.',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width <= 520;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC).withValues(alpha: 0.80),
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.80),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pushNamed(context, '/gig-finder');
                              },
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: Text(
                                    '←',
                                    style: TextStyle(
                                      color: skyNavy,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Hi, Bronny',
                            style: TextStyle(
                              color: skyNavy,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
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
                                child: const Icon(Icons.person, color: navy),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 176),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1024),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              PremiumBadge(),
                              SizedBox(width: 10),
                              Text(
                                'Job ID: #GPC-9921',
                                style: TextStyle(color: bodyText, fontSize: 14),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Premium Organic Provisions Pickup',
                            style: TextStyle(
                              color: navy,
                              fontSize: isSmall ? 34 : 38,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (isSmall)
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoText('Starts Today, 15:30'),
                                SizedBox(height: 8),
                                InfoText('₱45.00 Fixed'),
                                SizedBox(height: 8),
                                InfoText('2.1 miles total'),
                              ],
                            )
                          else
                            const Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                InfoText('Starts Today, 15:30'),
                                InfoText('₱45.00 Fixed'),
                                InfoText('2.1 miles total'),
                              ],
                            ),

                          const SizedBox(height: 12),

                          const Text(
                            'Curated selection of seasonal organic produce and artisanal pantry staples. This task requires meticulous quality inspection and strict adherence to temperature-controlled handling for all perishable items.',
                            style: TextStyle(
                              color: bodyText,
                              fontSize: 15,
                              height: 1.65,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(4),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 334,
                                    child: Image.asset(
                                      'assets/images/grocery.png',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: const Color(0xFFECEEF1),
                                              child: const Center(
                                                child: Icon(
                                                  Icons
                                                      .shopping_basket_outlined,
                                                  color: navy,
                                                  size: 64,
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.90,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'QUALITY GUARANTEED',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          const SectionTitle(title: 'Logistics Pathway'),

                          const SizedBox(height: 14),

                          Column(
                            children: logistics
                                .map(
                                  (stop) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: LogisticsCard(stop: stop),
                                  ),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: 12),

                          const SectionTitle(title: 'Client Mandate'),

                          const SizedBox(height: 14),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1E2E6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Critical Instructions',
                                  style: TextStyle(
                                    color: darkText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...mandates.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.only(
                                            top: 8.5,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: navy,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              color: bodyText,
                                              fontSize: 14,
                                              height: 1.45,
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

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temp-Controlled',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Maintain Cold Chain',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD8DADD,
                              ).withValues(alpha: 0.40),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fully Insured & Bonded via Steward Platinum Protection',
                                  style: TextStyle(
                                    color: bodyText,
                                    fontSize: 12,
                                    letterSpacing: 0.48,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    PartnerLogo(
                                      path: 'assets/images/partner_a.png',
                                    ),
                                    const SizedBox(width: 10),
                                    PartnerLogo(
                                      path: 'assets/images/partner_b.png',
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
                ),
              ),
            ],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 78,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.80),
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: SafeArea(
                top: false,
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1024),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [navy, teal],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/execution-status',
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Accept Task',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          color: const Color(0xFFE1E2E6),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {},
                            child: const SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.chat_bubble_outline,
                                color: navy,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    );
  }
}

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFC7E7FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Premium Errand',
        style: TextStyle(
          color: Color(0xFF001E2E),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String text;

  const InfoText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF40484E),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 32, height: 2, color: navy),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class LogisticsCard extends StatelessWidget {
  final LogisticsStop stop;

  const LogisticsCard({super.key, required this.stop});

  static const Color navy = Color(0xFF003C56);
  static const Color green = Color(0xFF004035);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);

  @override
  Widget build(BuildContext context) {
    final Color sideColor = stop.tone == LogisticsTone.pickup ? navy : green;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: sideColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stop.type,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.76,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stop.title,
            style: const TextStyle(
              color: darkText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stop.address,
            style: const TextStyle(color: bodyText, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            stop.contact,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerLogo extends StatelessWidget {
  final String path;

  const PartnerLogo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF003C56).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LogisticsStop {
  final String type;
  final String title;
  final String address;
  final String contact;
  final LogisticsTone tone;

  const LogisticsStop({
    required this.type,
    required this.title,
    required this.address,
    required this.contact,
    required this.tone,
  });
}

enum LogisticsTone { pickup, dropoff }

class RunnerBottomNav extends StatelessWidget {
  final String active;

  const RunnerBottomNav({super.key, required this.active});

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
            color: Colors.black.withValues(alpha: 0.06),
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
            onTap: () {
              Navigator.pushNamed(context, '/gig-finder');
            },
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
            Icon(icon, color: color, size: 24),
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

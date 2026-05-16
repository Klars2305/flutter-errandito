import 'package:flutter/material.dart';

class ErrandExecutionPaymentPage extends StatelessWidget {
  const ErrandExecutionPaymentPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color green = Color(0xFF004035);

  static const List<PurchaseItem> items = [
    PurchaseItem(qty: '03', name: 'Organic Produce Mix', price: '\$28.40'),
    PurchaseItem(qty: '01', name: 'Artisan Bakery Selection', price: '\$18.25'),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  color: const Color(0xFFF8FAFC).withValues(alpha: 0.90),
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
                                    color: const Color(0xFFE1E2E6),
                                    child: const Icon(
                                      Icons.person,
                                      color: navy,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Hi, Bronny',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
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
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 124),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 672),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Errand in Progress',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Whole Foods Market • Organic Grocery Run',
                                      style: TextStyle(
                                        color: bodyText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC7E7FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'In-Progress',
                                  style: TextStyle(
                                    color: Color(0xFF001E2E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Container(
                            height: 200,
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/location.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFECEEF1),
                                      child: const Center(
                                        child: Icon(
                                          Icons.location_on,
                                          color: navy,
                                          size: 64,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.08),
                                        Colors.black.withValues(alpha: 0.45),
                                      ],
                                    ),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Venue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.96,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Whole Foods, Columbus Circle',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: darkText.withValues(alpha: 0.06),
                                  blurRadius: 48,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Digital Purchase Interface',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: FundBox(
                                        label: 'Available Funds',
                                        amount: '\$142.85',
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: FundBox(
                                        label: 'Budget Limit',
                                        amount: '\$250.00',
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    width: double.infinity,
                                    height: 6,
                                    color: const Color(0xFFE7E8EB),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: 0.57,
                                        child: Container(color: navy),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                const Text(
                                  'SCANNED ITEMS SUMMARY',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.96,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Column(
                                  children: items
                                      .map(
                                        (item) => PurchaseItemRow(item: item),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 16),

                                SizedBox(
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
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
                                            '/payment-earnings',
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(14),
                                          child: Text(
                                            'Pay with Errand Budget',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Center(
                                  child: Text(
                                    'Payments are securely processed via StewardPay Vault',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD8DADD,
                              ).withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bonded & Insured',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Purchase covered up to \$500',
                                      style: TextStyle(
                                        color: darkText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Help',
                                    style: TextStyle(
                                      color: navy,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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

          const Align(
            alignment: Alignment.bottomCenter,
            child: RunnerBottomNav(active: 'earnings'),
          ),
        ],
      ),
    );
  }
}

class FundBox extends StatelessWidget {
  final String label;
  final String amount;

  const FundBox({super.key, required this.label, required this.amount});

  static const Color navy = Color(0xFF003C56);
  static const Color bodyText = Color(0xFF40484E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: bodyText,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.88,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: const TextStyle(
            color: navy,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class PurchaseItemRow extends StatelessWidget {
  final PurchaseItem item;

  const PurchaseItemRow({super.key, required this.item});

  static const Color green = Color(0xFF004035);
  static const Color borderColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor.withValues(alpha: 0.20)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item.qty,
                style: const TextStyle(
                  color: green,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                color: Color(0xFF191C1E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            item.price,
            style: const TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseItem {
  final String qty;
  final String name;
  final String price;

  const PurchaseItem({
    required this.qty,
    required this.name,
    required this.price,
  });
}

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
            label: 'Errands',
            isActive: active == 'errands',
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

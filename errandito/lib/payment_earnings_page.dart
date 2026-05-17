import 'package:flutter/material.dart';

class PaymentEarningsPage extends StatelessWidget {
  const PaymentEarningsPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkGreen = Color(0xFF17584C);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);

  static const List<TransactionItem> transactions = [
    TransactionItem(
      title: 'Architectural Consultation: Site Visit',
      meta: 'Oct 21, 2023 • Project ID: #ARCH-9821',
      amount: '+₱450.00',
      status: 'Completed',
      pending: false,
    ),
    TransactionItem(
      title: 'Curated Material Procurement',
      meta: 'Oct 20, 2023 • Project ID: #MAT-4421',
      amount: '+₱1,280.00',
      status: 'Completed',
      pending: false,
    ),
    TransactionItem(
      title: 'Documentation & Permitting Support',
      meta: 'Oct 19, 2023 • Project ID: #PERM-1102',
      amount: '+₱320.50',
      status: 'Pending',
      pending: true,
    ),
    TransactionItem(
      title: 'Precision Landscape Supervision',
      meta: 'Oct 18, 2023 • Project ID: #LAND-3392',
      amount: '+₱790.00',
      status: 'Completed',
      pending: false,
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
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [navy, teal],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withValues(alpha: 0.12),
                                  blurRadius: 48,
                                  offset: const Offset(0, 24),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL WEEKLY EARNINGS',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFC7E7FF,
                                    ).withValues(alpha: 0.90),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.96,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '₱5,840.50',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 46,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '+12% from last week',
                                  style: TextStyle(
                                    color: Color(0xFFC7E7FF),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {},
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            'Withdraw Now',
                                            style: TextStyle(
                                              color: navy,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Material(
                                      color: teal.withValues(alpha: 0.40),
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Report',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          const StatCard(
                            label: 'PENDING PAYOUT',
                            value: '₱412.00',
                            note: 'Est. arrival: Friday, Oct 24',
                            showProgress: true,
                          ),

                          const SizedBox(height: 10),

                          const StatCard(
                            label: 'TASK COMPLETIONS',
                            value: '24',
                            note:
                                'Top 5% of stewards in your region this week.',
                            showProgress: false,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transaction History',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Detailed breakdown of your stewardship earnings.',
                                      style: TextStyle(
                                        color: bodyText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Filter',
                                  style: TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Column(
                            children: transactions.map((tx) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TransactionTile(transaction: tx),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 2),

                          SizedBox(
                            width: double.infinity,
                            child: Material(
                              color: const Color(0xFFE7E8EB),
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'View Full History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final bool showProgress;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.showProgress,
  });

  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color darkGreen = Color(0xFF17584C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: bodyText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: darkText,
              fontSize: 34,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          if (showProgress) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 6,
                color: const Color(0xFFE1E2E6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.65,
                    child: Container(color: darkGreen),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ] else
            const SizedBox(height: 4),
          Text(
            note,
            style: const TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionTile({super.key, required this.transaction});

  static const Color darkText = Color(0xFF191C1E);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    final Color badgeBg = transaction.pending
        ? const Color(0xFFD6E5EC)
        : const Color(0xFFB1EFDE);
    final Color badgeText = transaction.pending
        ? const Color(0xFF58676D)
        : const Color(0xFF00201A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.meta,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  transaction.status,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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

class TransactionItem {
  final String title;
  final String meta;
  final String amount;
  final String status;
  final bool pending;

  const TransactionItem({
    required this.title,
    required this.meta,
    required this.amount,
    required this.status,
    required this.pending,
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
            icon: Icons.search_outlined,
            label: 'Gigs',
            isActive: active == 'gigs',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/gig-finder');
            },
          ),
          BottomNavItem(
            icon: Icons.assignment_outlined,
            label: 'Status',
            isActive: active == 'status',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/execution-status');
            },
          ),
          BottomNavItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Earnings',
            isActive: active == 'earnings',
            onTap: () {},
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

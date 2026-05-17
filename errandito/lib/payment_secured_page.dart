import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/errand_service.dart';

class PaymentSecuredPage extends StatelessWidget {
  const PaymentSecuredPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F6F8);
  static const Color borderColor = Color(0xFFE0E7EC);

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadErrand() async {
    final ref = await ErrandService.latestRequesterErrand(
      allowedStatuses: {
        'pending_payment',
        'posted',
        'paid',
        'booked',
        'booked_paid',
        'paid_waiting_runner',
        'booked_paid',
        'accepted',
        'in_progress',
        'on_the_way',
      },
    );
    return ref?.get();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width <= 390;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          future: _loadErrand(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() ?? <String, dynamic>{};
            final serviceType = (data['serviceType'] ?? 'Errand').toString();
            final serviceAddress = (data['serviceAddress'] ?? 'Panabo City, Davao del Norte').toString();
            final runnerName = (data['runnerName'] ?? 'Runner will be assigned').toString();
            final budget = (data['budget'] ?? data['pay'] ?? '₱0').toString();
            final timeSlot = (data['timeSlot'] ?? 'Not set').toString();
            final preferredDate = (data['preferredDate'] ?? 'Not set').toString();
            final status = (data['status'] ?? 'paid_waiting_runner').toString();

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(isNarrow ? 16 : 24, 18, isNarrow ? 16 : 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ERRANDDITO',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          Material(
                            color: const Color(0xFFE6F0F4),
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => Navigator.pushReplacementNamed(context, '/home-dashboard'),
                              child: const SizedBox(
                                width: 42,
                                height: 42,
                                child: Icon(Icons.person, color: navy),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            colors: [navy, teal],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: navy.withOpacity(0.18),
                              blurRadius: 34,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.22)),
                              ),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Online Payment Successful',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Payment was simulated successfully. Errandito records the platform fee and holds the runner payout until the requester confirms completion.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.86),
                                fontSize: 13.5,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: navy.withOpacity(0.05),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: lightPanel,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.receipt_long_outlined, color: teal),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Payment Details',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _DetailRow(label: 'Payment Method', value: 'Online Payment Simulation'),
                            _DetailRow(label: 'Amount Due', value: budget, highlight: true),
                            _DetailRow(label: 'Payment Status', value: 'Paid online • payout held'),
                            _DetailRow(label: 'Errand Status', value: _prettyStatus(status)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Errand Summary',
                              style: TextStyle(
                                color: navy,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _InfoTile(icon: Icons.local_shipping_outlined, label: 'Service', value: serviceType),
                            _InfoTile(icon: Icons.place_outlined, label: 'Location', value: serviceAddress),
                            _InfoTile(icon: Icons.person_outline, label: 'Runner', value: runnerName),
                            _InfoTile(icon: Icons.event_outlined, label: 'Preferred Date', value: preferredDate),
                            _InfoTile(icon: Icons.access_time_rounded, label: 'Time Slot', value: timeSlot),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _GradientButton(
                        label: 'Continue to Activity',
                        onTap: () => Navigator.pushReplacementNamed(context, '/activity'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _prettyStatus(String status) {
    switch (status) {
      case 'booked_paid':
        return 'Booked • Online payment held';
      case 'paid_waiting_runner':
        return 'Paid • Waiting for runner';
      case 'accepted':
        return 'Accepted by runner';
      case 'in_progress':
        return 'In progress';
      case 'on_the_way':
        return 'Runner on the way';
      case 'completed':
        return 'Completed';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _DetailRow({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: PaymentSecuredPage.bodyText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: PaymentSecuredPage.navy,
                fontSize: highlight ? 22 : 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: PaymentSecuredPage.lightPanel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: PaymentSecuredPage.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: PaymentSecuredPage.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: PaymentSecuredPage.navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
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

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [PaymentSecuredPage.navy, PaymentSecuredPage.teal],
          ),
          boxShadow: [
            BoxShadow(
              color: PaymentSecuredPage.navy.withOpacity(0.20),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

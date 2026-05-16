import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/errand_service.dart';

class ReviewPayPage extends StatefulWidget {
  const ReviewPayPage({super.key});

  @override
  State<ReviewPayPage> createState() => _ReviewPayPageState();
}

class _ReviewPayPageState extends State<ReviewPayPage> {
  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF536167);
  static const Color borderColor = Color(0xFFE0E7EC);

  bool _isPaying = false;

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadErrand() async {
    final ref = await ErrandService.latestRequesterErrand(
      allowedStatuses: {
        'pending_payment',
        'posted',
        'paid',
        'booked',
        'booked_paid',
      },
    );
    return ref?.get();
  }

  Future<void> _pay() async {
    setState(() => _isPaying = true);
    try {
      await ErrandService.payLatestRequesterErrand();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment secured. Errand is now visible to runner(s).'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/payment');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          future: _loadErrand(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final hasErrand = data != null;
            final title = (data?['serviceType'] ?? 'No active errand')
                .toString();
            final address = (data?['serviceAddress'] ?? 'Post an errand first')
                .toString();
            final runner = (data?['runnerName'] ?? 'No runner selected yet')
                .toString();
            final budget = (data?['budget'] ?? data?['pay'] ?? '₱0').toString();
            final paymentStatus = (data?['paymentStatus'] ?? 'unpaid')
                .toString();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => Navigator.pop(context),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: navy,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Review & Pay',
                              style: TextStyle(
                                color: navy,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (!hasErrand)
                        _Panel(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.receipt_long_outlined,
                                color: navy,
                                size: 44,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No errand to pay',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please post an errand before opening payment.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: bodyText,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _GradientButton(
                                label: 'Post Errand',
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/servicehub',
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [navy, teal],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ERRAND SUMMARY',
                                style: TextStyle(
                                  color: Color(0xFFBFE7F4),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _WhiteInfo(
                                label: 'SERVICE LOCATION',
                                value: address,
                              ),
                              const SizedBox(height: 12),
                              _WhiteInfo(label: 'RUNNER', value: runner),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Panel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Summary',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _SummaryRow(label: 'Errand fee', value: budget),
                              const SizedBox(height: 10),
                              const _SummaryRow(
                                label: 'Platform fee',
                                value: '₱0',
                              ),
                              const Divider(height: 26),
                              _SummaryRow(
                                label: 'Total',
                                value: budget,
                                bold: true,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Status: ${paymentStatus.toUpperCase()}',
                                style: const TextStyle(
                                  color: bodyText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _GradientButton(
                          label: _isPaying
                              ? 'Processing Payment...'
                              : 'Pay & Publish Errand',
                          onTap: _isPaying ? null : _pay,
                        ),
                      ],
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
}

class _Panel extends StatelessWidget {
  final Widget child;
  const _Panel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ReviewPayPageState.borderColor),
      ),
      child: child,
    );
  }
}

class _WhiteInfo extends StatelessWidget {
  final String label;
  final String value;
  const _WhiteInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: _ReviewPayPageState.bodyText,
              fontSize: 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: _ReviewPayPageState.navy,
            fontSize: bold ? 18 : 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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
            colors: [_ReviewPayPageState.navy, _ReviewPayPageState.teal],
          ),
          boxShadow: [
            BoxShadow(
              color: _ReviewPayPageState.navy.withValues(alpha: 0.20),
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
              padding: const EdgeInsets.all(17),
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

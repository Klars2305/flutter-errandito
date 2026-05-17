import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/errand_service.dart';
import 'services/payment_service.dart';

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
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E7EC);
  static const Color softPanel = Color(0xFFF2F6F8);
  static const Color green = Color(0xFF17584C);

  bool _isBusy = false;

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadErrand([
    String? errandId,
  ]) async {
    if (errandId != null && errandId.isNotEmpty) {
      return ErrandService.errands.doc(errandId).get();
    }

    final ref = await ErrandService.latestRequesterErrand(
      allowedStatuses: {
        'pending_payment',
        'posted',
        'paid',
        'booked',
        'booked_paid',
        'paid_waiting_runner',
        'accepted',
        'in_progress',
        'on_the_way',
      },
    );
    return ref?.get();
  }

  String _paymentLabel(String method, String status) {
    if (method == 'cod' && status == 'cod_pending') {
      return 'Cash on Delivery selected';
    }
    if (method == 'hitpay' && status == 'pending') {
      return 'HitPay payment pending';
    }
    if (status == 'paid') {
      return 'Payment confirmed';
    }
    if (status == 'failed') {
      return 'Payment failed';
    }
    return 'No payment method selected';
  }

  Future<void> _chooseCOD(String errandId) async {
    setState(() => _isBusy = true);
    try {
      await ErrandService.chooseCashOnDelivery(errandId: errandId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cash on Delivery selected.')),
      );
      Navigator.pushReplacementNamed(context, '/payment');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('COD error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _startHitPay(String errandId) async {
    setState(() => _isBusy = true);
    try {
      await PaymentService.startHitPayCheckout(errandId: errandId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'HitPay checkout opened. After paying, return here and tap Check Payment Status.',
          ),
        ),
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('HitPay error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _checkHitPay(String errandId) async {
    setState(() => _isBusy = true);
    try {
      final status = await PaymentService.checkHitPayPaymentStatus(
        errandId: errandId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment status: $status')),
      );

      if (status == 'paid') {
        Navigator.pushReplacementNamed(context, '/payment');
      } else {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Check payment error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _simulateOnlinePayment() async {
    setState(() => _isBusy = true);
    try {
      await ErrandService.payLatestRequesterErrand();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mock payment confirmed. Your errand is now active.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/payment');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to confirm mock payment: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width <= 390;
    final args = ModalRoute.of(context)?.settings.arguments;
    final String? routeErrandId =
        args is String && args.isNotEmpty ? args : null;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          future: _loadErrand(routeErrandId),
          builder: (context, snapshot) {
            final doc = snapshot.data;
            final data = doc?.data();
            final hasErrand = data != null;
            final errandId = doc?.id ?? '';
            final title = (data?['serviceType'] ?? 'No active errand').toString();
            final address = (data?['serviceAddress'] ?? 'Post an errand first').toString();
            final runner = (data?['runnerName'] ?? 'No runner selected yet').toString();
            final budget = (data?['budget'] ?? data?['pay'] ?? '₱0').toString();
            final preferredDate = (data?['preferredDate'] ?? 'Not set').toString();
            final timeSlot = (data?['timeSlot'] ?? 'Not set').toString();
            final paymentStatus = (data?['paymentStatus'] ?? 'unpaid').toString();
            final paymentMethod = (data?['paymentMethod'] ?? '').toString();
            final paymentCheckoutUrl = (data?['paymentCheckoutUrl'] ?? '').toString();

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isNarrow ? 16 : 22,
                20,
                isNarrow ? 16 : 22,
                32,
              ),
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
                                child: Icon(Icons.arrow_back_rounded, color: navy),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Payment Method',
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
                              const Icon(Icons.receipt_long_outlined, color: navy, size: 44),
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
                                'Please post an errand and select a runner first.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: bodyText, fontSize: 13, height: 1.4),
                              ),
                              const SizedBox(height: 18),
                              _GradientButton(
                                label: 'Post Errand',
                                onTap: () => Navigator.pushReplacementNamed(context, '/servicehub'),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [navy, teal],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
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
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                                ),
                                child: const Icon(Icons.payments_outlined, color: Colors.white, size: 30),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Choose how to pay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Use Cash on Delivery for local errands, or test online payment through HitPay Sandbox.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.86),
                                  fontSize: 13,
                                  height: 1.45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Panel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Errand Summary',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _InfoTile(icon: Icons.local_shipping_outlined, label: 'Service', value: title),
                              _InfoTile(icon: Icons.place_outlined, label: 'Location', value: address),
                              _InfoTile(icon: Icons.person_outline, label: 'Runner', value: runner),
                              _InfoTile(icon: Icons.event_outlined, label: 'Preferred Date', value: preferredDate),
                              _InfoTile(icon: Icons.access_time_rounded, label: 'Time Slot', value: timeSlot),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Panel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Breakdown',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _SummaryRow(label: 'Errand fee', value: budget),
                              const SizedBox(height: 10),
                              const _SummaryRow(label: 'Platform fee', value: '₱0'),
                              const Divider(height: 26),
                              _SummaryRow(label: 'Total', value: budget, bold: true),
                              const SizedBox(height: 14),
                              _StatusBox(
                                label: _paymentLabel(paymentMethod, paymentStatus),
                                isPaid: paymentStatus == 'paid',
                              ),
                              if (paymentCheckoutUrl.isNotEmpty && paymentStatus == 'pending') ...[
                                const SizedBox(height: 10),
                                const Text(
                                  'Checkout was created. Complete payment in HitPay, then tap Check Payment Status.',
                                  style: TextStyle(
                                    color: bodyText,
                                    fontSize: 12,
                                    height: 1.35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (paymentStatus == 'paid')
                          _GradientButton(
                            label: 'Continue to Activity',
                            onTap: _isBusy
                                ? null
                                : () => Navigator.pushReplacementNamed(context, '/activity'),
                          )
                        else ...[
                          _GradientButton(
                            label: _isBusy ? 'Processing...' : 'Cash on Delivery',
                            onTap: _isBusy ? null : () => _chooseCOD(errandId),
                          ),
                          const SizedBox(height: 12),
                          _OutlineActionButton(
                            label: _isBusy
                                ? 'Processing...'
                                : paymentStatus == 'pending' && paymentMethod == 'hitpay'
                                    ? 'Open / Continue HitPay Sandbox'
                                    : 'Pay Online with HitPay Sandbox',
                            icon: Icons.credit_card_rounded,
                            onTap: _isBusy ? null : () => _startHitPay(errandId),
                          ),
                          const SizedBox(height: 12),
                          _OutlineActionButton(
                            label: _isBusy ? 'Checking...' : 'Check Payment Status',
                            icon: Icons.refresh_rounded,
                            onTap: _isBusy ? null : () => _checkHitPay(errandId),
                          ),
                          const SizedBox(height: 12),
                          _TextActionButton(
                            label: 'Use Mock Payment Instead',
                            onTap: _isBusy ? null : _simulateOnlinePayment,
                          ),
                        ],
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
        boxShadow: [
          BoxShadow(
            color: _ReviewPayPageState.navy.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBox extends StatelessWidget {
  final String label;
  final bool isPaid;

  const _StatusBox({
    required this.label,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPaid
            ? _ReviewPayPageState.green.withOpacity(0.10)
            : _ReviewPayPageState.softPanel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: isPaid ? _ReviewPayPageState.green : _ReviewPayPageState.teal,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isPaid ? _ReviewPayPageState.green : _ReviewPayPageState.bodyText,
                fontSize: 12.5,
                height: 1.45,
                fontWeight: FontWeight.w800,
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
        color: _ReviewPayPageState.softPanel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _ReviewPayPageState.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: _ReviewPayPageState.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: _ReviewPayPageState.navy,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

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
            fontSize: bold ? 22 : 15,
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
              color: _ReviewPayPageState.navy.withOpacity(0.20),
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

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _ReviewPayPageState.navy,
          side: const BorderSide(color: _ReviewPayPageState.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _TextActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _TextActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: _ReviewPayPageState.mutedText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

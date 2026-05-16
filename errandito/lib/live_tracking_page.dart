import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'services/errand_service.dart';

class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color green = Color(0xFF004035);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool compact = width <= 390;
    final double horizontalPadding = compact ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                112,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ErrandService.requesterErrandsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _ActivityShell(
                          child: _EmptyActivity(
                            icon: Icons.error_outline_rounded,
                            title: 'Unable to load activity',
                            message: snapshot.error.toString(),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final docs = snapshot.data!.docs.toList()
                        ..sort((a, b) {
                          final ta =
                              a.data()['updatedAt'] ?? a.data()['createdAt'];
                          final tb =
                              b.data()['updatedAt'] ?? b.data()['createdAt'];
                          if (ta is Timestamp && tb is Timestamp) {
                            return tb.compareTo(ta);
                          }
                          return 0;
                        });

                      final activeDocs = docs.where((doc) {
                        final status = (doc.data()['status'] ?? '').toString();
                        return status == 'accepted' ||
                            status == 'booked_paid' ||
                            status == 'paid' ||
                            status == 'booked' ||
                            status == 'pending_payment' ||
                            status == 'completed';
                      }).toList();

                      if (activeDocs.isEmpty) {
                        return _ActivityShell(
                          child: _EmptyActivity(
                            icon: Icons.assignment_outlined,
                            title: 'No active errand yet',
                            message:
                                'Post an errand and book a real runner. Once a runner accepts, the real details will appear here.',
                            action: () =>
                                Navigator.pushNamed(context, '/servicehub'),
                          ),
                        );
                      }

                      return _ActivityShell(
                        child: _RealActivityContent(doc: activeDocs.first),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RequesterBottomNav(active: 'activity'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityShell extends StatelessWidget {
  final Widget child;
  const _ActivityShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityTopBar(
          onNotificationTap: () {},
          onProfileTap: () =>
              Navigator.pushReplacementNamed(context, '/profile'),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _RealActivityContent extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const _RealActivityContent({required this.doc});

  static const Color navy = LiveTrackingPage.navy;
  static const Color teal = LiveTrackingPage.teal;
  static const Color bodyText = LiveTrackingPage.bodyText;
  static const Color lightPanel = LiveTrackingPage.lightPanel;

  String _statusLabel(String status, String paymentStatus) {
    if (status == 'accepted') return 'Accepted by Runner';
    if (status == 'booked_paid') return 'Booked and Paid';
    if (status == 'paid') return 'Paid • Waiting for Runner';
    if (status == 'pending_payment') return 'Waiting for Payment';
    if (status == 'completed') return 'Completed';
    return status.isEmpty ? 'Active' : status;
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final title = (data['serviceType'] ?? data['title'] ?? 'Errand').toString();
    final address =
        (data['serviceAddress'] ?? data['addressText'] ?? 'No service address')
            .toString();
    final runner = (data['runnerName'] ?? 'No runner assigned yet').toString();
    final requester = (data['requesterName'] ?? 'Requester').toString();
    final preferredDate = (data['preferredDate'] ?? 'No preferred date set')
        .toString();
    final timeSlot = (data['timeSlot'] ?? 'No time slot set').toString();
    final budget = (data['budget'] ?? data['pay'] ?? '₱0').toString();
    final status = (data['status'] ?? '').toString();
    final paymentStatus = (data['paymentStatus'] ?? 'unpaid').toString();
    final serviceLat = (data['serviceLat'] as num?)?.toDouble();
    final serviceLng = (data['serviceLng'] as num?)?.toDouble();
    final runnerLat = (data['runnerLat'] as num?)?.toDouble();
    final runnerLng = (data['runnerLng'] as num?)?.toDouble();
    final label = _statusLabel(status, paymentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [navy, teal],
            ),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Errand ID: ${doc.id}',
                      style: const TextStyle(
                        color: Color(0xFFE5F4F7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _StatusPanel(
          label: label,
          runner: runner,
          paymentStatus: paymentStatus,
        ),
        const SizedBox(height: 18),
        _LiveMapCard(
          serviceAddress: address,
          serviceLat: serviceLat,
          serviceLng: serviceLng,
          runnerLat: runnerLat,
          runnerLng: runnerLng,
        ),
        const SizedBox(height: 18),
        _InfoCard(
          title: 'Active Delivery Details',
          icon: Icons.receipt_long_rounded,
          children: [
            _DetailRow(label: 'Service', value: title),
            _DetailRow(label: 'Location', value: address),
            _DetailRow(label: 'Requester', value: requester),
            _DetailRow(label: 'Runner', value: runner),
            _DetailRow(label: 'Preferred Date', value: preferredDate),
            _DetailRow(label: 'Time Slot', value: timeSlot),
            _DetailRow(label: 'Budget', value: budget),
            _DetailRow(label: 'Payment', value: paymentStatus),
          ],
        ),
        const SizedBox(height: 18),
        _InfoCard(
          title: 'Instructions',
          icon: Icons.notes_rounded,
          children: [
            Text(
              (data['instructions'] ?? 'No instructions provided.')
                      .toString()
                      .trim()
                      .isEmpty
                  ? 'No instructions provided.'
                  : data['instructions'].toString(),
              style: const TextStyle(
                color: bodyText,
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightPanel,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Journey',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              JourneyStep(done: true, label: 'Errand posted by requester'),
              JourneyStep(
                done: paymentStatus == 'paid',
                label: 'Payment secured',
              ),
              JourneyStep(
                done: runner != 'No runner assigned yet',
                label: 'Runner booked',
              ),
              JourneyStep(
                done: status == 'accepted' || status == 'completed',
                label: 'Runner accepted the errand',
              ),
              JourneyStep(
                done: status == 'completed',
                label: 'Errand completed',
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (runner != 'No runner assigned yet')
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(colors: [navy, teal]),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/execution-messaging',
                    arguments: doc.id,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(17),
                    child: Text(
                      'Message Runner',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LiveMapCard extends StatelessWidget {
  final String serviceAddress;
  final double? serviceLat;
  final double? serviceLng;
  final double? runnerLat;
  final double? runnerLng;

  const _LiveMapCard({
    required this.serviceAddress,
    required this.serviceLat,
    required this.serviceLng,
    required this.runnerLat,
    required this.runnerLng,
  });

  static const Color navy = LiveTrackingPage.navy;
  static const Color teal = LiveTrackingPage.teal;
  static const Color bodyText = LiveTrackingPage.bodyText;

  static const LatLng panaboCenter = LatLng(7.3081, 125.6841);

  @override
  Widget build(BuildContext context) {
    final LatLng servicePoint = serviceLat != null && serviceLng != null
        ? LatLng(serviceLat!, serviceLng!)
        : panaboCenter;

    final LatLng? runnerPoint = runnerLat != null && runnerLng != null
        ? LatLng(runnerLat!, runnerLng!)
        : null;

    final LatLng mapCenter = runnerPoint ?? servicePoint;

    return Container(
      height: 280,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          FlutterMap(
            key: ValueKey('${mapCenter.latitude},${mapCenter.longitude}'),
            options: MapOptions(initialCenter: mapCenter, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.errandito',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: servicePoint,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: navy,
                      size: 44,
                    ),
                  ),
                  if (runnerPoint != null)
                    Marker(
                      point: runnerPoint,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.delivery_dining_rounded,
                        color: teal,
                        size: 42,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_rounded, color: navy, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service location',
                          style: TextStyle(
                            color: navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          serviceAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: bodyText,
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (runnerPoint != null) ...[
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.delivery_dining_rounded,
                                color: teal,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Runner is live on the map',
                                style: TextStyle(
                                  color: teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final String label;
  final String runner;
  final String paymentStatus;
  const _StatusPanel({
    required this.label,
    required this.runner,
    required this.paymentStatus,
  });

  static const Color navy = LiveTrackingPage.navy;
  static const Color green = LiveTrackingPage.green;
  static const Color bodyText = LiveTrackingPage.bodyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F3EC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.assignment_turned_in_rounded, color: green),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Runner: $runner • Payment: $paymentStatus',
                  style: const TextStyle(
                    color: bodyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
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

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  static const Color navy = LiveTrackingPage.navy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: navy, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  static const Color navy = LiveTrackingPage.navy;
  static const Color bodyText = LiveTrackingPage.bodyText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: bodyText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JourneyStep extends StatelessWidget {
  final bool done;
  final String label;
  const JourneyStep({super.key, required this.done, required this.label});

  static const Color navy = LiveTrackingPage.navy;
  static const Color mutedText = LiveTrackingPage.mutedText;
  static const Color green = LiveTrackingPage.green;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: done ? green : mutedText,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: done ? navy : mutedText,
                fontSize: 13,
                fontWeight: done ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  const _EmptyActivity({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  static const Color navy = LiveTrackingPage.navy;
  static const Color teal = LiveTrackingPage.teal;
  static const Color bodyText = LiveTrackingPage.bodyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: navy, size: 48),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: bodyText,
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [navy, teal]),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: action,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Book a Service',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
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

class _ActivityTopBar extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  const _ActivityTopBar({
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  static const Color navy = LiveTrackingPage.navy;
  static const Color mutedText = LiveTrackingPage.mutedText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: TextStyle(
                color: navy,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Track your real active errand',
              style: TextStyle(
                color: mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _IconCircle(
              icon: Icons.notifications_rounded,
              onTap: onNotificationTap,
            ),
            const SizedBox(width: 10),
            _IconCircle(icon: Icons.person_rounded, onTap: onProfileTap),
          ],
        ),
      ],
    );
  }
}

class _IconCircle extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconCircle({required this.icon, required this.onTap});

  @override
  State<_IconCircle> createState() => _IconCircleState();
}

class _IconCircleState extends State<_IconCircle> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: _hovering
            ? LiveTrackingPage.navy.withValues(alpha: 0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(widget.icon, color: LiveTrackingPage.navy, size: 21),
          ),
        ),
      ),
    );
  }
}

class RequesterBottomNav extends StatelessWidget {
  final String active;
  const RequesterBottomNav({super.key, required this.active});

  static const Color navy = LiveTrackingPage.navy;
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
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: active == 'home',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/home-dashboard'),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.grid_view_rounded,
                activeIcon: Icons.grid_view_rounded,
                label: 'Services',
                isActive: active == 'services',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/servicehub'),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'messages',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/messages'),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment_rounded,
                label: 'Activity',
                isActive: active == 'activity',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/activity'),
              ),
            ),
            Expanded(
              child: NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _hovering = false;
  static const Color navy = LiveTrackingPage.navy;
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.isActive || _hovering;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
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
                : (_hovering
                      ? navy.withValues(alpha: 0.08)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isActive ? widget.activeIcon : widget.icon,
                color: widget.isActive
                    ? Colors.white
                    : (highlighted ? navy : inactive),
                size: 21,
              ),
              const SizedBox(height: 5),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.isActive
                      ? Colors.white
                      : (highlighted ? navy : inactive),
                  fontSize: 10,
                  fontWeight: widget.isActive
                      ? FontWeight.w800
                      : FontWeight.w600,
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

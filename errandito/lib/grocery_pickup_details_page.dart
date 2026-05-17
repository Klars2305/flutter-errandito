import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'services/errand_service.dart';

class GroceryPickupDetailsPage extends StatefulWidget {
  const GroceryPickupDetailsPage({super.key});

  @override
  State<GroceryPickupDetailsPage> createState() => _GroceryPickupDetailsPageState();
}

class _GroceryPickupDetailsPageState extends State<GroceryPickupDetailsPage> {
  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  String? _errandId;
  bool _readArgs = false;
  bool _isAccepting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readArgs) return;
    _readArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) _errandId = args;
  }

  Future<String?> _fallbackLatestOpenErrandId() async {
    final snap = await ErrandService.openErrandsStream().first;
    if (snap.docs.isEmpty) return null;
    final docs = snap.docs.toList()
      ..sort((a, b) {
        final ta = a.data()['updatedAt'] ?? a.data()['createdAt'];
        final tb = b.data()['updatedAt'] ?? b.data()['createdAt'];
        if (ta is Timestamp && tb is Timestamp) return tb.compareTo(ta);
        return 0;
      });
    return docs.first.id;
  }

  Future<void> _acceptErrand(String errandId) async {
    if (_isAccepting) return;
    setState(() => _isAccepting = true);

    try {
      await ErrandService.acceptErrand(errandId: errandId);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );
          await ErrandService.updateRunnerLocation(
            errandId: errandId,
            lat: position.latitude,
            lng: position.longitude,
          );
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errand accepted. Requester has been notified.')),
      );
      Navigator.pushReplacementNamed(context, '/execution-status', arguments: errandId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept errand: $e')),
      );
    } finally {
      if (mounted) setState(() => _isAccepting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.of(context).size.width <= 520;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: _errandId == null ? _fallbackLatestOpenErrandId() : Future.value(_errandId),
          builder: (context, idSnapshot) {
            if (!idSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: navy));
            }
            final errandId = idSnapshot.data;
            if (errandId == null || errandId.isEmpty) {
              return _EmptyDetails(onBack: () => Navigator.pop(context));
            }

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: ErrandService.errandStream(errandId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Unable to load errand details:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: navy));
                }
                final data = snapshot.data!.data();
                if (data == null) {
                  return _EmptyDetails(onBack: () => Navigator.pop(context));
                }

                final serviceType = (data['serviceType'] ?? data['title'] ?? 'Errand').toString();
                final address = (data['serviceAddress'] ?? data['pickup'] ?? 'Panabo City').toString();
                final requester = (data['requesterName'] ?? 'Requester').toString();
                final preferredDate = (data['preferredDate'] ?? 'No preferred date').toString();
                final timeSlot = (data['timeSlot'] ?? 'No time slot').toString();
                final budget = (data['budget'] ?? data['pay'] ?? '₱0').toString();
                final instructions = (data['instructions'] ?? 'No instructions provided.').toString().trim();
                final status = (data['status'] ?? 'open').toString();
                final paymentStatus = (data['paymentStatus'] ?? 'unpaid').toString();
                final canAccept = status == 'paid_waiting_runner' || status == 'booked_paid' || status == 'paid';

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(compact ? 18 : 24, 16, compact ? 18 : 24, 132),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : Navigator.pushReplacementNamed(context, '/gig-finder'),
                                    icon: const Icon(Icons.arrow_back_rounded, color: navy),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Errand Details',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(colors: [navy, teal]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: navy.withValues(alpha: 0.16),
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
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.16),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            serviceType.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          budget,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      serviceType,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: compact ? 30 : 36,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Requester: $requester',
                                      style: const TextStyle(
                                        color: Color(0xFFE5F4F7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              _DetailsCard(
                                children: [
                                  _InfoRow(icon: Icons.storefront_outlined, label: 'Pickup', value: address),
                                  _InfoRow(icon: Icons.location_on_outlined, label: 'Drop-off', value: address),
                                  _InfoRow(icon: Icons.calendar_month_rounded, label: 'Date', value: preferredDate),
                                  _InfoRow(icon: Icons.schedule_rounded, label: 'Time', value: timeSlot),
                                  _InfoRow(icon: Icons.payments_outlined, label: 'Payment', value: paymentStatus),
                                  _InfoRow(icon: Icons.info_outline_rounded, label: 'Status', value: status),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _DetailsCard(
                                title: 'Instructions',
                                children: [
                                  Text(
                                    instructions.isEmpty ? 'No instructions provided.' : instructions,
                                    style: const TextStyle(
                                      color: bodyText,
                                      fontSize: 14,
                                      height: 1.55,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _DetailsCard(
                                title: 'Important',
                                children: const [
                                  Text(
                                    'After finishing the errand, mark it as delivered. The requester has the final authority to confirm completion and release your payout.',
                                    style: TextStyle(
                                      color: bodyText,
                                      fontSize: 13,
                                      height: 1.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -8),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          top: false,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _OutlinedButton(
                                    label: 'Message',
                                    icon: Icons.chat_bubble_outline_rounded,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/execution-messaging',
                                      arguments: errandId,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _PrimaryButton(
                                    label: _isAccepting ? 'Accepting...' : canAccept ? 'Accept Task' : 'Open Status',
                                    icon: canAccept ? Icons.check_rounded : Icons.assignment_turned_in_rounded,
                                    onTap: _isAccepting
                                        ? null
                                        : canAccept
                                            ? () => _acceptErrand(errandId)
                                            : () => Navigator.pushNamed(context, '/execution-status', arguments: errandId),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _EmptyDetails extends StatelessWidget {
  final VoidCallback onBack;
  const _EmptyDetails({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.assignment_outlined, color: Color(0xFF003C56), size: 54),
            const SizedBox(height: 14),
            const Text(
              'No errand selected',
              style: TextStyle(
                color: Color(0xFF003C56),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Open a posted errand from the Gigs page to view its real details.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF40484E), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 18),
            _PrimaryButton(label: 'Back to Gigs', icon: Icons.arrow_back_rounded, onTap: onBack),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _DetailsCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E9EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: Color(0xFF003C56),
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF005477), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF71787E),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF003C56),
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: onTap == null ? const Color(0xFF94A3B8) : const Color(0xFF005477),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlinedButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E9EF)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF003C56), size: 19),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF003C56),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

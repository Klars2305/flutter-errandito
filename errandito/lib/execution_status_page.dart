import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'services/errand_service.dart';

class ExecutionStatusUpdatePage extends StatefulWidget {
  const ExecutionStatusUpdatePage({super.key});

  @override
  State<ExecutionStatusUpdatePage> createState() =>
      _ExecutionStatusUpdatePageState();
}

class _ExecutionStatusUpdatePageState extends State<ExecutionStatusUpdatePage> {
  static const Color background = Color(0xFFF8F9FD);

  StreamSubscription<Position>? _positionSub;
  String? _trackingErrandId;
  bool _readRouteArguments = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readRouteArguments) return;
    _readRouteArguments = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _trackingErrandId = args;
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<void> _startLiveTracking(String errandId) async {
    _trackingErrandId = errandId;
    final allowed = await _ensureLocationPermission();

    if (!allowed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required for live tracking.'),
        ),
      );
      return;
    }

    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      final activeErrandId = _trackingErrandId;
      if (activeErrandId == null) return;

      ErrandService.updateRunnerLocation(
        errandId: activeErrandId,
        lat: position.latitude,
        lng: position.longitude,
      );
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Widget _buildTaskBody() {
    final errandId = _trackingErrandId;

    if (errandId != null && errandId.isNotEmpty) {
      return StreamBuilder(
        stream: ErrandService.errandStream(errandId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _ExecutionLoadingCard();
          }

          if (snapshot.hasError) {
            return _ExecutionMessageCard(
              icon: Icons.error_outline_rounded,
              title: 'Unable to load task',
              message: snapshot.error.toString(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const _ExecutionMessageCard(
              icon: Icons.assignment_late_outlined,
              title: 'Task not found',
              message: 'This accepted task may have been removed or changed.',
            );
          }

          final data = snapshot.data!.data() ?? <String, dynamic>{};
          return _ExecutionTaskContent(
            errandId: errandId,
            data: data,
            onStartTracking: () => _startLiveTracking(errandId),
          );
        },
      );
    }

    return StreamBuilder(
      stream: ErrandService.activeRunnerErrandsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ExecutionLoadingCard();
        }

        if (snapshot.hasError) {
          return _ExecutionMessageCard(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load active task',
            message: snapshot.error.toString(),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const _ExecutionMessageCard(
            icon: Icons.assignment_outlined,
            title: 'No active task',
            message:
                'Accept a task first. Your current task progress will appear here.',
          );
        }

        final doc = docs.first;
        final data = doc.data();
        return _ExecutionTaskContent(
          errandId: doc.id,
          data: data,
          onStartTracking: () => _startLiveTracking(doc.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool narrowScreen = screenWidth <= 390;
    final double horizontalPadding = narrowScreen ? 18 : 22;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                112,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusHeader(
                        onBackTap: () {
                          Navigator.pushNamed(context, '/gig-finder');
                        },
                        onProfileTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildTaskBody(),
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RunnerBottomNav(active: 'tasks'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExecutionTaskContent extends StatelessWidget {
  final String errandId;
  final Map<String, dynamic> data;
  final VoidCallback onStartTracking;

  const _ExecutionTaskContent({
    required this.errandId,
    required this.data,
    required this.onStartTracking,
  });

  @override
  Widget build(BuildContext context) {
    final status = (data['status'] ?? 'accepted').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrentErrandSummaryCard(data: data),
        const SizedBox(height: 18),
        StatusProgressCard(
          errandId: errandId,
          status: status,
          onStartTracking: onStartTracking,
        ),
        const SizedBox(height: 18),
        TaskRouteCard(data: data),
        const SizedBox(height: 18),
        TaskActionCard(
          onChatTap: () {
            Navigator.pushNamed(
              context,
              '/execution-messaging',
              arguments: errandId,
            );
          },
          onCompleteTap: status == 'completed'
              ? null
              : () async {
                  await ErrandService.updateErrandProgress(
                    errandId: errandId,
                    status: 'completed',
                  );

                  if (!context.mounted) return;
                  Navigator.pushNamed(context, '/task-complete-earnings');
                },
        ),
      ],
    );
  }
}

class _ExecutionLoadingCard extends StatelessWidget {
  const _ExecutionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const StatusCard(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(color: Color(0xFF003C56)),
        ),
      ),
    );
  }
}

class _ExecutionMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ExecutionMessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        children: [
          Icon(icon, color: navy, size: 42),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedText,
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onProfileTap;

  const StatusHeader({
    super.key,
    required this.onBackTap,
    required this.onProfileTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBackTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: navy,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Task',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Update progress and complete the errand.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/profile.png',
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: navy.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: navy,
                    size: 23,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentErrandSummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const CurrentErrandSummaryCard({super.key, required this.data});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);

  String _statusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'on_the_way':
        return 'On the Way';
      case 'completed':
        return 'Completed';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceType =
        (data['serviceType'] ?? data['title'] ?? 'Accepted Errand').toString();
    final requester = (data['requesterName'] ?? 'Requester').toString();
    final budget = (data['budget'] ?? data['pay'] ?? '₱0').toString();
    final status = (data['status'] ?? 'accepted').toString();

    return StatusCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: navy,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Requester: $requester',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                budget,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: teal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusLabel(status),
                  style: const TextStyle(
                    color: teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
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

class StatusProgressCard extends StatelessWidget {
  final String errandId;
  final String status;
  final VoidCallback onStartTracking;

  const StatusProgressCard({
    super.key,
    required this.errandId,
    required this.status,
    required this.onStartTracking,
  });

  bool get isAccepted => status == 'accepted';
  bool get isInProgress => status == 'in_progress';
  bool get isOnTheWay => status == 'on_the_way';
  bool get isCompleted => status == 'completed';

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Task Progress',
            subtitle: 'Keep the requester updated as you complete the errand.',
          ),
          const SizedBox(height: 16),
          StatusTimeline(status: status),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: isAccepted ? 'Start Task' : 'Started',
                  icon: Icons.play_arrow_rounded,
                  onTap: isAccepted
                      ? () async {
                          await ErrandService.updateErrandProgress(
                            errandId: errandId,
                            status: 'in_progress',
                          );
                          onStartTracking();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Task started. Live tracking is active.',
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryActionButton(
                  label: isOnTheWay || isCompleted
                      ? 'On the Way'
                      : 'Set On the Way',
                  icon: Icons.delivery_dining_rounded,
                  onTap: isInProgress
                      ? () async {
                          await ErrandService.updateErrandProgress(
                            errandId: errandId,
                            status: 'on_the_way',
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Requester updated: runner is on the way.',
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  final String status;

  const StatusTimeline({super.key, required this.status});

  int get currentIndex {
    switch (status) {
      case 'accepted':
        return 0;
      case 'in_progress':
        return 1;
      case 'on_the_way':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      StatusStepData(
        title: 'Accepted',
        subtitle: 'You accepted this errand.',
        isDone: currentIndex >= 0,
      ),
      StatusStepData(
        title: 'In Progress',
        subtitle: 'You are handling the task.',
        isDone: currentIndex >= 1,
      ),
      StatusStepData(
        title: 'On the Way',
        subtitle: 'Going to the drop-off location.',
        isDone: currentIndex >= 2,
      ),
      StatusStepData(
        title: 'Delivered',
        subtitle: 'Task completed.',
        isDone: currentIndex >= 3,
      ),
    ];

    return Column(
      children: steps
          .asMap()
          .entries
          .map(
            (entry) => StatusTimelineItem(
              step: entry.value,
              isLast: entry.key == steps.length - 1,
            ),
          )
          .toList(),
    );
  }
}

class StatusTimelineItem extends StatelessWidget {
  final StatusStepData step;
  final bool isLast;

  const StatusTimelineItem({
    super.key,
    required this.step,
    required this.isLast,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: step.isDone ? teal : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: step.isDone ? teal : borderColor,
                  width: 1.4,
                ),
              ),
              child: Icon(
                step.isDone ? Icons.check_rounded : Icons.circle_outlined,
                color: step.isDone ? Colors.white : mutedText,
                size: step.isDone ? 16 : 12,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: step.isDone ? teal.withValues(alpha: 0.35) : borderColor,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    color: step.isDone ? navy : mutedText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.subtitle,
                  style: TextStyle(
                    color: step.isDone ? teal : mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskRouteCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TaskRouteCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pickup =
        (data['pickup'] ?? data['serviceAddress'] ?? 'No pickup location')
            .toString();
    final dropoff =
        (data['dropoff'] ?? data['serviceAddress'] ?? 'No drop-off location')
            .toString();
    final instructions =
        (data['instructions'] ?? 'No special instructions.').toString();
    final date = (data['preferredDate'] ?? 'No date set').toString();
    final time = (data['timeSlot'] ?? 'No time slot set').toString();

    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Route Details',
            subtitle: 'Confirm pickup and drop-off before completing.',
          ),
          const SizedBox(height: 14),
          RouteInfoRow(
            icon: Icons.storefront_outlined,
            label: 'Pickup',
            value: pickup,
          ),
          const SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Drop-off',
            value: dropoff,
          ),
          const SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.calendar_month_rounded,
            label: 'Date',
            value: date,
          ),
          const SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.schedule_rounded,
            label: 'Time',
            value: time,
          ),
          const SizedBox(height: 10),
          RouteInfoRow(
            icon: Icons.note_alt_outlined,
            label: 'Note',
            value: instructions,
          ),
        ],
      ),
    );
  }
}

class RouteInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const RouteInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: mutedText, size: 17),
        const SizedBox(width: 9),
        SizedBox(
          width: 62,
          child: Text(
            label,
            style: const TextStyle(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class TaskActionCard extends StatelessWidget {
  final VoidCallback onChatTap;
  final VoidCallback? onCompleteTap;

  const TaskActionCard({
    super.key,
    required this.onChatTap,
    required this.onCompleteTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return StatusCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Need to coordinate?',
            subtitle: 'Message the requester if pickup or delivery changes.',
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: navy, size: 19),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Use chat for substitutions, delays, or delivery confirmation.',
                    style: TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Open Chat',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: onChatTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryActionButton(
                  label: onCompleteTap == null ? 'Completed' : 'Complete',
                  icon: Icons.check_circle_outline_rounded,
                  onTap: onCompleteTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final Widget child;

  const StatusCard({super.key, required this.child});

  static const Color borderColor = Color(0xFFE6E9EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, required this.subtitle});

  static const Color navy = Color(0xFF003C56);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            color: mutedText,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color disabled = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isDisabled
              ? null
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [navy, teal],
                ),
          color: isDisabled ? disabled : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 17),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
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

class SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color borderColor = Color(0xFFE6E9EF);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return SizedBox(
      height: 44,
      child: Material(
        color: isDisabled ? const Color(0xFFF1F5F9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isDisabled ? mutedText : navy, size: 17),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isDisabled ? mutedText : navy,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
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

class StatusStepData {
  final String title;
  final String subtitle;
  final bool isDone;

  const StatusStepData({
    required this.title,
    required this.subtitle,
    required this.isDone,
  });
}

class RunnerBottomNav extends StatelessWidget {
  final String active;

  const RunnerBottomNav({super.key, required this.active});

  static const Color navy = Color(0xFF003C56);
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
              child: RunnerNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isActive: active == 'home',
                onTap: () {
                  Navigator.pushNamed(context, '/runner-home');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Gigs',
                isActive: active == 'gigs',
                onTap: () {
                  Navigator.pushNamed(context, '/gig-finder');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: 'Tasks',
                isActive: active == 'tasks',
                onTap: () {
                  Navigator.pushNamed(context, '/execution-status');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: active == 'runner-messages',
                onTap: () {
                  Navigator.pushNamed(context, '/runner-messages');
                },
              ),
            ),
            Expanded(
              child: RunnerNavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isActive: active == 'profile',
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const RunnerNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? navy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : inactive,
              size: 21,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive ? Colors.white : inactive,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

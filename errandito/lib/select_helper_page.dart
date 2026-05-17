import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'services/auth_service.dart';
import 'services/errand_service.dart';

class SelectHelperPage extends StatelessWidget {
  const SelectHelperPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E7EC);
  static const Color green = Color(0xFF17584C);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final String? selectedErrandId =
        args is String && args.isNotEmpty ? args : null;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 112),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _CircleIcon(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Select Your Runner',
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [navy, teal],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: navy.withValues(alpha: 0.16),
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available real runners',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Only accounts that chose the Runner role are shown here. If no runner has signed in, this list will be empty.',
                              style: TextStyle(
                                color: Color(0xFFD8EEF6),
                                height: 1.45,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: AuthService.runnersStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _EmptyPanel(
                              icon: Icons.error_outline_rounded,
                              title: 'Unable to load runners',
                              message: snapshot.error.toString(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final runners = snapshot.data!.docs
                              .where(
                                (doc) => doc.id != AuthService.currentUserId,
                              )
                              .toList();

                          if (runners.isEmpty) {
                            return const _EmptyPanel(
                              icon: Icons.person_search_rounded,
                              title: 'No runners available yet',
                              message:
                                  'Ask another user to sign in and choose Runner. Once they do, they will appear here automatically.',
                            );
                          }

                          runners.sort((a, b) {
                            final ar =
                                (a.data()['averageRating'] as num?)
                                    ?.toDouble() ??
                                0;
                            final br =
                                (b.data()['averageRating'] as num?)
                                    ?.toDouble() ??
                                0;
                            return br.compareTo(ar);
                          });

                          return Column(
                            children: runners.map((doc) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RunnerUserCard(
                                  doc: doc,
                                  onBook: () async {
                                    final data = doc.data();
                                    try {
                                      if (selectedErrandId != null) {
                                        await ErrandService.bookRunnerForErrand(
                                          errandId: selectedErrandId,
                                          runnerId: doc.id,
                                          runnerName:
                                              (data['fullName'] ?? 'Runner')
                                                  .toString(),
                                          runnerRole: (data['role'] ?? 'runner')
                                              .toString(),
                                        );
                                      } else {
                                        await ErrandService.bookRunner(
                                          runnerId: doc.id,
                                          runnerName:
                                              (data['fullName'] ?? 'Runner')
                                                  .toString(),
                                          runnerRole: (data['role'] ?? 'runner')
                                              .toString(),
                                        );
                                      }
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${data['fullName'] ?? 'Runner'} selected. Continue to payment.',
                                          ),
                                        ),
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        '/reviewpay',
                                        arguments: selectedErrandId,
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Unable to book runner: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                color: Colors.white.withValues(alpha: 0.88),
                child: SafeArea(
                  top: false,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: const Text(
                      'Tip: runner ratings come from completed errand reviews, not fixed dummy values.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunnerUserCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final VoidCallback onBook;

  const RunnerUserCard({super.key, required this.doc, required this.onBook});

  static const Color navy = SelectHelperPage.navy;
  static const Color teal = SelectHelperPage.teal;
  static const Color bodyText = SelectHelperPage.bodyText;
  static const Color mutedText = SelectHelperPage.mutedText;
  static const Color borderColor = SelectHelperPage.borderColor;
  static const Color green = SelectHelperPage.green;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final name = (data['fullName'] ?? data['email'] ?? 'Runner').toString();
    final email = (data['email'] ?? '').toString();
    final rating = (data['averageRating'] as num?)?.toDouble() ?? 0.0;
    final ratingCount = (data['ratingCount'] as num?)?.toInt() ?? 0;
    final completed = (data['completedErrands'] as num?)?.toInt() ?? 0;
    final isOnline = data['isOnline'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: teal.withValues(alpha: 0.10),
                child: Text(
                  name.isEmpty ? 'R' : name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email.isEmpty ? 'Runner account' : email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isOnline
                      ? green.withValues(alpha: 0.10)
                      : Colors.grey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isOnline ? green : mutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.star_rounded,
                  label: 'Rating',
                  value: ratingCount == 0
                      ? 'No ratings'
                      : rating.toStringAsFixed(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  icon: Icons.task_alt_rounded,
                  label: 'Completed',
                  value: '$completed',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
                  onTap: onBook,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Book This Runner',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: SelectHelperPage.teal, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: SelectHelperPage.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: SelectHelperPage.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: SelectHelperPage.navy),
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SelectHelperPage.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: SelectHelperPage.navy, size: 42),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SelectHelperPage.navy,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SelectHelperPage.mutedText,
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

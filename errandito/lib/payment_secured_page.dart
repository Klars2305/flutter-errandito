import 'package:flutter/material.dart';

class PaymentSecuredPage extends StatelessWidget {
  const PaymentSecuredPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);
  static const Color inactiveStep = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ERRANDDITO',
                    style: TextStyle(
                      color: navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
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
                            child: const Icon(
                              Icons.person,
                              color: navy,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                navy,
                                teal,
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '✓',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Payment Secured',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: darkText,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Your money is now safely held in Erraddito's secure banking-grade escrow vault until the task is done.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: bodyText,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: darkText.withOpacity(0.04),
                                blurRadius: 48,
                                offset: const Offset(0, 24),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  PaymentInfoBlock(
                                    label: 'TRANSACTION ID',
                                    value: '#ED-992-X24',
                                    alignRight: false,
                                    large: false,
                                  ),
                                  PaymentInfoBlock(
                                    label: 'SECURED AMOUNT',
                                    value: '\$124.50',
                                    alignRight: true,
                                    large: true,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 4,
                                  color: const Color(0xFFE1E2E6),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.66,
                                      child: Container(color: navy),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TimelineLabel(
                                    text: 'Funded',
                                    active: true,
                                  ),
                                  TimelineLabel(
                                    text: 'Secured',
                                    active: true,
                                  ),
                                  TimelineLabel(
                                    text: 'Release',
                                    active: false,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: lightPanel,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'System Escrow Protection Active',
                                      style: TextStyle(
                                        color: darkText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Your funds are protected by our mandatory escrow system. They will only be released once you confirm the errand is completed.',
                                      style: TextStyle(
                                        color: bodyText,
                                        fontSize: 12,
                                        height: 1.45,
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: lightPanel,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Image.asset(
                                    'assets/images/steward.png',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
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
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ASSIGNED STEWARD',
                                      style: TextStyle(
                                        color: mutedText,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Marcus Vance',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '4.9 (124 Errands)',
                                      style: TextStyle(
                                        color: bodyText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  navy,
                                  teal,
                                ],
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.pushNamed(context, '/message');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(22),
                                  child: Text(
                                    'Track Steward',
                                    textAlign: TextAlign.center,
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
                      ],
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

class PaymentInfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;
  final bool large;

  const PaymentInfoBlock({
    super.key,
    required this.label,
    required this.value,
    required this.alignRight,
    required this.large,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color darkText = Color(0xFF191C1E);
  static const Color mutedText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              color: large ? darkText : navy,
              fontSize: large ? 30 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineLabel extends StatelessWidget {
  final String text;
  final bool active;

  const TimelineLabel({
    super.key,
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: active ? const Color(0xFF003C56) : const Color(0xFFC0C7CE),
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

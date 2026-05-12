import 'package:flutter/material.dart';

class TaskCompletePage extends StatelessWidget {
  const TaskCompletePage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color lightPanel = Color(0xFFF2F3F7);
  static const Color mint = Color(0xFFB1EFDE);
  static const Color mintDark = Color(0xFF00201A);
  static const Color skyText = Color(0xFF8BC7EF);

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
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pushNamed(context, '/live-tracking');
                      },
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            '←',
                            style: TextStyle(
                              color: navy,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Task Summary',
                    style: TextStyle(
                      color: navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: mint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '✓',
                              style: TextStyle(
                                color: mintDark,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Task Completed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: navy,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your errand has been successfully delivered by your Steward.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: bodyText,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 18),

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Details',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const PaymentRow(
                                label: 'Service Fee',
                                value: '₱45.00',
                              ),
                              const SizedBox(height: 8),
                              const PaymentRow(
                                label: 'Mileage (12.4 mi)',
                                value: '₱8.60',
                              ),
                              const SizedBox(height: 8),
                              const PaymentRow(
                                label: 'Admin & Insurance',
                                value: '₱2.40',
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Color(0xFFECEEF1),
                                height: 1,
                              ),
                              const SizedBox(height: 10),
                              const PaymentRow(
                                label: 'Total Paid',
                                value: '₱56.00',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'YOUR STEWARD',
                                style: TextStyle(
                                  color: skyText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Image.asset(
                                        'assets/images/helper.png',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Christian Misal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Elite Steward • 4.98 Rating',
                                          style: TextStyle(
                                            color: skyText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: lightPanel,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Rate your experience',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Help the community by sharing your feedback on Julian's service.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: bodyText,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                '★★★★☆',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 30,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                minLines: 5,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  hintText:
                                      'Tell us what made this service exceptional...',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF71787E),
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
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
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/home-dashboard',
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(18),
                                        child: Text(
                                          'Submit Feedback',
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

class PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const PaymentRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? navy : bodyText,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? navy : darkText,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

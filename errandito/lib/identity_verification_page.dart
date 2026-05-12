import 'package:flutter/material.dart';

class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key});

  @override
  State<IdentityVerificationPage> createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  bool resent = false;

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color grayText = Color(0xFF536167);
  static const Color mutedText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width <= 430;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 64,
              color: const Color(0xFFF8FAFC).withOpacity(0.80),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 220),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 672),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verified Identity, Unmatched Security.',
                        style: TextStyle(
                          color: navy,
                          fontSize: isSmall ? 34 : 44,
                          fontWeight: FontWeight.w800,
                          height: isSmall ? 1.23 : 1.22,
                          letterSpacing: -1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Stewardship begins with trust. Please enter the 6-digit code sent to your registered device to confirm your identity and access our secure community.',
                        style: TextStyle(
                          color: grayText,
                          fontSize: 18,
                          height: 1.61,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isSmall ? 24 : 32),
                        decoration: BoxDecoration(
                          color: lightPanel,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                6,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    width: isSmall ? 44 : 48,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '·',
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      navy,
                                      teal,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF191C1E)
                                          .withOpacity(0.06),
                                      blurRadius: 48,
                                      offset: const Offset(0, 24),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/choose',
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Verify Identity',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_filled,
                                      color: grayText,
                                      size: 17,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'RESEND CODE IN 01:58',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.35,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      resent = true;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Resend Now',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                ),
                              ],
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

          if (resent)
            Positioned(
              left: 0,
              right: 0,
              bottom: 160,
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    'Code resent',
                    style: TextStyle(
                      color: mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
              color: const Color(0xFFD8DADD).withOpacity(0.40),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Container(
                          width: 16,
                          height: 21,
                          decoration: BoxDecoration(
                            color: grayText,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const Text(
                          'Secure verification powered by Steward-Shield™',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: grayText,
                            fontSize: 12,
                            height: 1.33,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Text(
                          'Compliance ID: STE- 8829-X',
                          style: TextStyle(
                            color: grayText.withOpacity(0.60),
                            fontSize: 12,
                            height: 1.33,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Text(
                          '© 2024 The Steward Service',
                          style: TextStyle(
                            color: grayText.withOpacity(0.60),
                            fontSize: 12,
                            height: 1.33,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OnboardingWalkthroughPage extends StatelessWidget {
  const OnboardingWalkthroughPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);
  static const Color green = Color(0xFF004035);
  static const Color dotInactive = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    final bool shortHeight = MediaQuery.of(context).size.height <= 760;

    return Scaffold(
      backgroundColor: background,
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D4C6B),
              Color(0xFF2F88B2),
              background,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 512,
              ),
              child: SizedBox(
                width: 342,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: shortHeight ? 20 : 24,
                        vertical: shortHeight ? 22 : 28,
                      ),
                      decoration: BoxDecoration(
                        color: background.withOpacity(0.80),
                        borderRadius: BorderRadius.circular(
                          shortHeight ? 30 : 40,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF191C1E).withOpacity(0.06),
                            blurRadius: 48,
                            offset: const Offset(0, 24),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 237,
                                child: Text(
                                  'Expert Help at Your Door',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: shortHeight ? 31 : 36,
                                    fontWeight: FontWeight.w800,
                                    height: shortHeight ? 1.22 : 1.25,
                                    letterSpacing: -0.9,
                                  ),
                                ),
                              ),
                              SizedBox(height: shortHeight ? 10 : 14),
                              SizedBox(
                                width: 251,
                                child: Text(
                                  "Your architectural partner for life's everyday logistical challenges. Premium stewardship for every errand.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: bodyText,
                                    fontSize: shortHeight ? 16 : 18,
                                    fontWeight: FontWeight.w400,
                                    height: shortHeight ? 1.56 : 1.625,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: shortHeight ? 18 : 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: navy,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const OnboardingDot(),
                              const SizedBox(width: 8),
                              const OnboardingDot(),
                              const SizedBox(width: 8),
                              const OnboardingDot(),
                            ],
                          ),

                          SizedBox(height: shortHeight ? 18 : 24),

                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
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
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: shortHeight ? 14 : 16,
                                        ),
                                        child: const Text(
                                          'Next',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            height: 1.55,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: shortHeight ? 4 : 8,
                                      ),
                                      child: const Text(
                                        'Skip for now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: navy,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: shortHeight ? 12 : 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: green,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Secure & Insured Service',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: bodyText,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 1,
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
      ),
    );
  }
}

class OnboardingDot extends StatelessWidget {
  const OnboardingDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFC0C7CE),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

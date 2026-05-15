import 'package:flutter/material.dart';

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key});

  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color subtitleText = Color(0xFF4E616D);
  static const Color mutedText = Color(0xFF72787E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 222,
              child: Container(
                width: 256,
                height: 251,
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 114, 24, 66),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 448),
                          child: Column(
                            children: [
                              Column(
                                children: const [
                                  SizedBox(
                                    width: 175,
                                    child: Text(
                                      'Your time, redefined.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: teal,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        height: 1.25,
                                        letterSpacing: -0.9,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: 320,
                                    child: Text(
                                      'The premium errand concierge connecting high-achievers with elite stewards.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: subtitleText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.625,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 40),

                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.70),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: teal.withOpacity(0.10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ChooseOptionButton(
                                      title: 'Become a Requester',
                                      description:
                                          'Delegate your tasks to expert runners.',
                                      isPrimary: true,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/home-dashboard',
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    ChooseOptionButton(
                                      title: 'Join as a Runner',
                                      description:
                                          'Monetize your skills as a premium steward.',
                                      isPrimary: false,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/gig-finder',
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),

                              const Row(
                                children: [
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.verified_outlined,
                                      label: 'Vetted',
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.payments_outlined,
                                      label: 'Premium Pay',
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.access_time,
                                      label: 'Flexibility',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 0, 35, 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: const Text(
                          "By continuing, you agree to ERRANDITO's Terms of Service & Privacy Policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 10,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.arrow_back,
                              color: Color.fromRGBO(25, 28, 30, 0.7),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'ERRANDITO',
                        style: TextStyle(
                          color: teal,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3.6,
                        ),
                      ),
                    ],
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

class ChooseOptionButton extends StatelessWidget {
  final String title;
  final String description;
  final bool isPrimary;
  final VoidCallback onTap;

  const ChooseOptionButton({
    super.key,
    required this.title,
    required this.description,
    required this.isPrimary,
    required this.onTap,
  });

  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color subtitleText = Color(0xFF4E616D);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isPrimary ? teal : Colors.white;
    final Color borderColor =
        isPrimary ? teal : const Color(0xFF72787E).withOpacity(0.20);
    final Color titleColor = isPrimary ? Colors.white : darkText;
    final Color descriptionColor =
        isPrimary ? Colors.white.withOpacity(0.80) : subtitleText;
    final Color arrowColor = isPrimary ? Colors.white : teal;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.55,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward,
                    color: arrowColor,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: descriptionColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.42,
                    ),
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

class ChooseFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const ChooseFeature({
    super.key,
    required this.icon,
    required this.label,
  });

  static const Color teal = Color(0xFF005477);
  static const Color mutedText = Color(0xFF72787E);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: mutedText.withOpacity(0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: teal,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

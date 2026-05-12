import 'package:flutter/material.dart';

class SignUpScreenPage extends StatelessWidget {
  const SignUpScreenPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color panel = Color(0xFFF2F3F7);
  static const Color borderColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64,
              color: const Color(0xFFF8FAFC).withOpacity(0.80),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 112, 24, 170),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 896),
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: darkText.withOpacity(0.06),
                          blurRadius: 48,
                          offset: const Offset(0, 24),
                        ),
                      ],
                    ),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register Account',
                            style: TextStyle(
                              color: navy,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.33,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Experience the pinnacle of personal stewardship.',
                            style: TextStyle(
                              color: bodyText,
                              fontSize: 14,
                              height: 1.42,
                            ),
                          ),

                          const SizedBox(height: 32),

                          const SignUpField(
                            label: 'Email Address',
                            value: 'julian@steward.com',
                          ),

                          const SizedBox(height: 18),

                          const SignUpField(
                            label: 'Phone Number',
                            value: '+1 (555) 000-0000',
                          ),

                          const SizedBox(height: 18),

                          const SignUpField(
                            label: 'Password',
                            value: '••••••••••••',
                            showEye: true,
                          ),

                          const SizedBox(height: 26),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: panel,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: borderColor),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'I agree to the Terms of Service and Privacy Policy.',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

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
                                    color: navy.withOpacity(0.15),
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
                                    Navigator.pushNamed(context, '/account-created');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: bodyText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xFFD8DADD).withOpacity(0.30),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CertIcon(),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Steward Certified Insurance Protection',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: bodyText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '© 2024 The Steward Errand Services. All Rights Reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
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

class SignUpField extends StatelessWidget {
  final String label;
  final String value;
  final bool showEye;

  const SignUpField({
    super.key,
    required this.label,
    required this.value,
    this.showEye = false,
  });

  static const Color darkText = Color(0xFF191C1E);
  static const Color mutedText = Color(0xFF71787E);
  static const Color panel = Color(0xFFF2F3F7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: darkText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 16,
                  ),
                ),
              ),
              if (showEye)
                const Icon(
                  Icons.visibility_outlined,
                  color: mutedText,
                  size: 20,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CertIcon extends StatelessWidget {
  const CertIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF003C56),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

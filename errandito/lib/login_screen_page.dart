import 'package:flutter/material.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  String role = 'requester';

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedText = Color(0xFF536167);
  static const Color softText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);
  static const Color divider = Color(0xFFE1E2E6);

  void signIn() {
    Navigator.pushNamed(
      context,
      '/account-created',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width <= 430;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  32,
                  24,
                  isSmall ? 124 : 150,
                ),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: isSmall ? 360 : 896,
                    minHeight: 668,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: darkText.withOpacity(0.06),
                        blurRadius: 48,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 294,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: navy,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.75,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Please enter your credentials to access your dashboard.',
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 14,
                                height: 1.42,
                              ),
                            ),

                            const SizedBox(height: 28),

                            const LoginTextField(
                              label: 'Email Address',
                              value: 'name@steward.com',
                            ),

                            const SizedBox(height: 18),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Interface',
                                  style: TextStyle(
                                    color: darkText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.325,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lightPanel,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: role,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: softText,
                                      ),
                                      style: const TextStyle(
                                        color: softText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'requester',
                                          child: Text('Requester'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'runner',
                                          child: Text('Runner'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          role = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        color: darkText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.325,
                                      ),
                                    ),
                                    Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lightPanel,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '••••••••',
                                          style: TextStyle(
                                            color: softText,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.visibility_outlined,
                                        color: softText,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
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
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: signIn,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.login,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: divider,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 29,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lightPanel,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Or continue with',
                                    style: TextStyle(
                                      color: softText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: SocialButton(
                                    icon: Icons.g_mobiledata,
                                    label: 'Google',
                                    onTap: signIn,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: SocialButton(
                                    icon: Icons.apple,
                                    label: 'Apple',
                                    onTap: signIn,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                child: const Text(
                                  "Don't have an account? Join Us",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
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
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: isSmall ? 92 : 118,
              width: double.infinity,
              color: lightPanel,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FooterLink(text: 'Privacy Policy'),
                    SizedBox(width: isSmall ? 18 : 40),
                    FooterLink(text: 'Terms of Service'),
                    SizedBox(width: isSmall ? 18 : 40),
                    FooterLink(text: 'Support'),
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

class LoginTextField extends StatelessWidget {
  final String label;
  final String value;

  const LoginTextField({
    super.key,
    required this.label,
    required this.value,
  });

  static const Color darkText = Color(0xFF191C1E);
  static const Color softText = Color(0xFF71787E);
  static const Color lightPanel = Color(0xFFF2F3F7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: darkText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.325,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: lightPanel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: softText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const Color lightPanel = Color(0xFFF2F3F7);
  static const Color bodyText = Color(0xFF40484E);
  static const Color darkText = Color(0xFF191C1E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: lightPanel,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: darkText,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: bodyText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }
}

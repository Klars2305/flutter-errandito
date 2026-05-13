import 'package:flutter/material.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color softText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E4EA);
  static const Color divider = Color(0xFFE1E2E6);

  void signIn() {
    Navigator.pushNamed(context, '/account-created');

    // Later, when role selection is ready:
    // Navigator.pushNamed(context, '/role-selection');
  }

  void goToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  void forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot password screen coming soon.')),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool shortScreen = screen.height < 720;
    final bool veryShortScreen = screen.height < 640;
    final bool narrowScreen = screen.width <= 390;

    final double horizontalPadding = narrowScreen ? 18 : 24;
    final double cardPadding = veryShortScreen ? 20 : 24;
    final double logoSize = veryShortScreen ? 44 : 50;
    final double titleSize = veryShortScreen ? 25 : 28;
    final double inputHeight = veryShortScreen ? 52 : 56;
    final double buttonHeight = veryShortScreen ? 52 : 56;

    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: shortScreen ? 12 : 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (shortScreen ? 24 : 40),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 420),
                        padding: EdgeInsets.all(cardPadding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: darkText.withOpacity(0.045),
                              blurRadius: 32,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [navy, teal],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: navy.withOpacity(0.14),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.delivery_dining_rounded,
                                color: Colors.white,
                                size: veryShortScreen ? 23 : 26,
                              ),
                            ),

                            SizedBox(height: veryShortScreen ? 14 : 18),

                            Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.4,
                              ),
                            ),

                            SizedBox(height: veryShortScreen ? 6 : 8),

                            Text(
                              'To sign in to your ERRANDITO account,\nenter your email and password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: softText,
                                fontSize: veryShortScreen ? 12.5 : 13.5,
                                height: 1.35,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(height: veryShortScreen ? 18 : 24),

                            LoginInputField(
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.mail_outline_rounded,
                              height: inputHeight,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(height: veryShortScreen ? 10 : 12),

                            LoginInputField(
                              controller: passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_outline_rounded,
                              height: inputHeight,
                              obscureText: obscurePassword,
                              suffixIcon: IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: softText,
                                  size: 19,
                                ),
                              ),
                            ),

                            SizedBox(height: veryShortScreen ? 7 : 9),

                            TextButton(
                              onPressed: forgotPassword,
                              style: TextButton.styleFrom(
                                foregroundColor: navy,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                              ),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: veryShortScreen ? 12.5 : 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: veryShortScreen ? 10 : 13),

                            GradientMainButton(
                              label: 'Continue',
                              height: buttonHeight,
                              onTap: signIn,
                            ),

                            SizedBox(height: veryShortScreen ? 17 : 20),

                            const DividerWithText(
                              text: "Don't have an account yet?",
                            ),

                            SizedBox(height: veryShortScreen ? 12 : 15),

                            FullSoftButton(
                              label: 'Create an account',
                              height: buttonHeight,
                              onTap: goToSignUp,
                            ),

                            SizedBox(height: veryShortScreen ? 16 : 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MinimalSocialIcon(
                                  icon: Icons.facebook_rounded,
                                  tooltip: 'Sign in with Facebook',
                                  onTap: signIn,
                                ),
                                const SizedBox(width: 28),
                                MinimalSocialIcon(
                                  icon: Icons.apple_rounded,
                                  tooltip: 'Sign in with Apple',
                                  onTap: signIn,
                                ),
                                const SizedBox(width: 28),
                                MinimalSocialIcon(
                                  icon: Icons.g_mobiledata_rounded,
                                  tooltip: 'Sign in with Google',
                                  isGoogle: true,
                                  onTap: signIn,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: veryShortScreen ? 12 : 16),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TermsText(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final double height;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const LoginInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.height,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  static const Color softText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E4EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF191C1E),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: softText,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: softText, size: 20),
          prefixIconConstraints: BoxConstraints(
            minWidth: 48,
            minHeight: height,
          ),
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(vertical: (height - 22) / 2),
        ),
      ),
    );
  }
}

class GradientMainButton extends StatelessWidget {
  final String label;
  final double height;
  final VoidCallback onTap;

  const GradientMainButton({
    super.key,
    required this.label,
    required this.height,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [navy, teal],
          ),
          boxShadow: [
            BoxShadow(
              color: navy.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullSoftButton extends StatelessWidget {
  final String label;
  final double height;
  final VoidCallback onTap;

  const FullSoftButton({
    super.key,
    required this.label,
    required this.height,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color borderColor = Color(0xFFE0E4EA);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MinimalSocialIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isGoogle;
  final VoidCallback onTap;

  const MinimalSocialIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isGoogle = false,
  });

  static const Color iconColor = Color(0xFF2E3B2F);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Center(
            child: Icon(icon, color: iconColor, size: isGoogle ? 30 : 22),
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  static const Color divider = Color(0xFFE1E2E6);
  static const Color softText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: divider, thickness: 1, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(
              color: softText,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: divider, thickness: 1, height: 1)),
      ],
    );
  }
}

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  static const Color softText = Color(0xFF71787E);
  static const Color darkText = Color(0xFF191C1E);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          color: softText,
          fontSize: 11.5,
          height: 1.35,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: 'By clicking “Continue”, I agree with the '),
          TextSpan(
            text: 'Term Sheet',
            style: TextStyle(
              color: darkText,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: darkText,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}

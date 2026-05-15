import 'package:flutter/material.dart';

class SignUpScreenPage extends StatefulWidget {
  const SignUpScreenPage({super.key});

  @override
  State<SignUpScreenPage> createState() => _SignUpScreenPageState();
}

class _SignUpScreenPageState extends State<SignUpScreenPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool agreedToTerms = false;

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color softText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E4EA);

  void createAccount() {
    if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Privacy Policy.'),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/identity');

    // Later, when role selection is ready:
    // Navigator.pushNamed(context, '/role-selection');
  }

  void goToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool shortScreen = screen.height < 760;
    final bool veryShortScreen = screen.height < 670;
    final bool narrowScreen = screen.width <= 390;

    final double horizontalPadding = narrowScreen ? 18 : 24;
    final double cardPadding = veryShortScreen ? 20 : 24;
    final double logoSize = veryShortScreen ? 44 : 50;
    final double titleSize = veryShortScreen ? 24 : 28;
    final double inputHeight = veryShortScreen ? 50 : 54;
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
                  child: Container(
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
                        AppLogo(
                          size: logoSize,
                          iconSize: veryShortScreen ? 22 : 25,
                        ),

                        SizedBox(height: veryShortScreen ? 13 : 17),

                        Text(
                          'Create Account',
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
                          'Join ERRANDITO and start requesting\nor completing errands nearby.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: softText,
                            fontSize: veryShortScreen ? 12.5 : 13.5,
                            height: 1.35,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: veryShortScreen ? 16 : 22),

                        SignUpInputField(
                          controller: nameController,
                          hintText: 'Full name',
                          icon: Icons.person_outline_rounded,
                          height: inputHeight,
                          textInputAction: TextInputAction.next,
                        ),

                        SizedBox(height: veryShortScreen ? 9 : 11),

                        SignUpInputField(
                          controller: emailController,
                          hintText: 'Email',
                          icon: Icons.mail_outline_rounded,
                          height: inputHeight,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),

                        SizedBox(height: veryShortScreen ? 9 : 11),

                        SignUpInputField(
                          controller: phoneController,
                          hintText: 'Phone number',
                          icon: Icons.phone_outlined,
                          height: inputHeight,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),

                        SizedBox(height: veryShortScreen ? 9 : 11),

                        SignUpInputField(
                          controller: passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline_rounded,
                          height: inputHeight,
                          obscureText: obscurePassword,
                          textInputAction: TextInputAction.done,
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

                        SizedBox(height: veryShortScreen ? 12 : 15),

                        TermsCheckRow(
                          value: agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              agreedToTerms = value ?? false;
                            });
                          },
                        ),

                        SizedBox(height: veryShortScreen ? 14 : 18),

                        GradientMainButton(
                          label: 'Create Account',
                          height: buttonHeight,
                          onTap: createAccount,
                        ),

                        SizedBox(height: veryShortScreen ? 16 : 20),

                        LoginPrompt(onTap: goToLogin),
                      ],
                    ),
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

class AppLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AppLogo({super.key, required this.size, required this.iconSize});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
        Icons.person_add_alt_1_rounded,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}

class SignUpInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final double height;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  const SignUpInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.height,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
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
        textInputAction: textInputAction,
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

class TermsCheckRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color softText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: navy,
            side: const BorderSide(color: Color(0xFFE0E4EA), width: 1.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: softText,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(text: 'I agree with the '),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(
                    color: navy,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: navy,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
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

class LoginPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const LoginPrompt({super.key, required this.onTap});

  static const Color navy = Color(0xFF003C56);
  static const Color softText = Color(0xFF71787E);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Already registered?',
          style: TextStyle(
            color: softText,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: navy,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.only(left: 5, right: 5),
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: navy,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

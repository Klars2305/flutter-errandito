import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/auth_service.dart';

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
  
  bool isLoading = false;
  bool obscurePassword = true;
  bool agreedToTerms = false;

  void goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }
  
  String _firebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color softText = Color(0xFF71787E);
  static const Color borderColor = Color(0xFFE0E4EA);
  static const Color divider = Color(0xFFE1E2E6);

  Future<void> createAccount() async {
    final String fullName = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String password = passwordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
        ),
      );
      return;
    }

    if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Privacy Policy.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/identity');
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_firebaseErrorMessage(error))));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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

    final bool veryShortScreen = screen.height < 680;
    final bool shortScreen = screen.height < 760;
    final bool narrowScreen = screen.width <= 390;

    final double horizontalPadding = narrowScreen ? 18 : 24;
    final double pageVerticalPadding = veryShortScreen ? 8 : 14;

    final double cardPadding = veryShortScreen
        ? 16
        : shortScreen
        ? 18
        : 22;

    final double logoSize = veryShortScreen
        ? 72
        : shortScreen
        ? 84
        : 96;

    final double titleSize = veryShortScreen
        ? 23
        : shortScreen
        ? 25
        : 27;

    final double inputHeight = veryShortScreen ? 47 : 51;
    final double buttonHeight = veryShortScreen ? 48 : 52;

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
                vertical: pageVerticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (pageVerticalPadding * 2),
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
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: logoSize,
                          height: logoSize,
                          child: Image.asset(
                            'assets/images/ErrandditoLogo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.delivery_dining_rounded,
                                color: navy,
                                size: veryShortScreen ? 36 : 44,
                              );
                            },
                          ),
                        ),

                        SizedBox(height: veryShortScreen ? 8 : 12),

                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            height: 1.08,
                            letterSpacing: -0.4,
                          ),
                        ),

                        SizedBox(height: veryShortScreen ? 6 : 8),

                        Text(
                          'Join ERRANDITO and start requesting\nor completing errands nearby.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: softText,
                            fontSize: veryShortScreen ? 11.8 : 13,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: veryShortScreen ? 14 : 18),

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
                            padding: EdgeInsets.zero,
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
                              size: 18,
                            ),
                          ),
                        ),

                        SizedBox(height: veryShortScreen ? 10 : 12),

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
                          label: isLoading
                              ? 'Creating Account...'
                              : 'Create Account',
                          height: buttonHeight,
                          onTap: isLoading ? () {} : createAccount,
                        ),

                        SizedBox(height: veryShortScreen ? 14 : 18),

                        const DividerWithText(text: 'Already have an account?'),

                        SizedBox(height: veryShortScreen ? 10 : 12),

                        TextButton(
                          onPressed: goToLogin,
                          style: TextButton.styleFrom(
                            foregroundColor: navy,
                            minimumSize: const Size.fromHeight(36),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: softText,
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, color: softText, size: 19),
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
  static const Color darkText = Color(0xFF191C1E);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-8, -4),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: navy,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(color: Color(0xFFE0E4EA), width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: softText,
                  fontSize: 11.8,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(text: 'I agree with the '),
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
                  fontSize: 14.5,
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
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Text(
            text,
            style: const TextStyle(
              color: softText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: divider, thickness: 1, height: 1)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {

  static const Color backgroundTop = Color(0xFFF8FBFC);
  static const Color backgroundBottom = Color(0xFFEFF5F7);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005C7A);
  static const Color subtitleText = Color(0xFF506272);
  static const Color mutedText = Color(0xFF7A8790);
  static const Color borderColor = Color(0xFFDDE7EC);

    Future<void> chooseRequester() async {
    await AuthService.updateUserRole('requester');

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  Future<void> chooseRunner() async {
    await AuthService.updateUserRole('runner');

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/gig-finder');
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool narrow = screen.width <= 390;
    final bool veryShort = screen.height < 650;

    return Scaffold(
      backgroundColor: backgroundBottom,
      body: Container(
        width: double.infinity,
        height: screen.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundTop, backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: -95,
                top: veryShort ? 145 : 190,
                child: Container(
                  width: veryShort ? 190 : 230,
                  height: veryShort ? 190 : 230,
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.055),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      narrow ? 18 : 22,
                      6,
                      narrow ? 18 : 22,
                      0,
                    ),
                    child: const ChooseHeader(),
                  ),

                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          narrow ? 20 : 24,
                          veryShort ? 10 : 18,
                          narrow ? 20 : 24,
                          veryShort ? 16 : 22,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Choose your role',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: veryShort
                                      ? 30
                                      : narrow
                                      ? 33
                                      : 36,
                                  fontWeight: FontWeight.w900,
                                  height: 1.08,
                                  letterSpacing: -1.0,
                                ),
                              ),

                              SizedBox(height: veryShort ? 10 : 12),

                              Text(
                                'Start by choosing how you want to use Errandito.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subtitleText,
                                  fontSize: veryShort
                                      ? 12.5
                                      : narrow
                                      ? 13.5
                                      : 14.5,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),

                              SizedBox(height: veryShort ? 22 : 28),

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(veryShort ? 14 : 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.94),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: borderColor.withOpacity(0.9),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: navy.withOpacity(0.055),
                                      blurRadius: 24,
                                      offset: const Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                   ChooseOptionButton(
                                      title: 'Requester',
                                      description:
                                          'Post errands and get help from nearby runners.',
                                      icon: Icons.assignment_outlined,
                                      isPrimary: true,
                                      compact: veryShort,
                                      onTap: chooseRequester,
                                    ),

                                    SizedBox(height: veryShort ? 10 : 12),

                                   ChooseOptionButton(
                                      title: 'Runner',
                                      description:
                                          'Accept tasks and help people with local errands.',
                                      icon: Icons.assignment_turned_in_outlined,
                                      isPrimary: false,
                                      compact: veryShort,
                                      onTap: chooseRunner,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: veryShort ? 18 : 22),

                              const Row(
                                children: [
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.verified_outlined,
                                      label: 'Verified',
                                    ),
                                  ),
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.location_on_outlined,
                                      label: 'Nearby',
                                    ),
                                  ),
                                  Expanded(
                                    child: ChooseFeature(
                                      icon: Icons.payments_outlined,
                                      label: 'Secure',
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: veryShort ? 16 : 20),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "By continuing, you agree to ERRANDITO's Terms of Service and Privacy Policy.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mutedText,
                                    fontSize: 10,
                                    height: 1.45,
                                    fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}

class ChooseHeader extends StatelessWidget {
  const ChooseHeader({super.key});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 34,
                height: 34,
                child: Icon(Icons.arrow_back_rounded, color: navy, size: 21),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseOptionButton extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isPrimary;
  final bool compact;
  final VoidCallback onTap;

  const ChooseOptionButton({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isPrimary,
    required this.compact,
    required this.onTap,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005C7A);
  static const Color subtitleText = Color(0xFF506272);
  static const Color borderColor = Color(0xFFDDE7EC);

  @override
  Widget build(BuildContext context) {
    final bool narrow = MediaQuery.of(context).size.width <= 390;

    final Color titleColor = isPrimary ? Colors.white : navy;
    final Color descriptionColor = isPrimary
        ? Colors.white.withOpacity(0.84)
        : subtitleText;
    final Color iconColor = isPrimary ? Colors.white : teal;
    final Color arrowColor = isPrimary ? navy : teal;

    final double iconBoxSize = compact
        ? 50
        : narrow
        ? 56
        : 60;

    final double arrowBoxSize = compact ? 36 : 40;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 15 : 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: isPrimary ? null : Colors.white,
            gradient: isPrimary
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [navy, teal],
                  )
                : null,
            border: Border.all(
              color: isPrimary ? Colors.transparent : borderColor,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: navy.withOpacity(isPrimary ? 0.13 : 0.035),
                blurRadius: isPrimary ? 18 : 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPrimary
                      ? Colors.white.withOpacity(0.10)
                      : const Color(0xFFF1F6F8),
                  border: Border.all(
                    color: isPrimary
                        ? Colors.white.withOpacity(0.16)
                        : borderColor,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: compact ? 24 : 28),
              ),

              SizedBox(width: compact ? 13 : 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: compact
                            ? 17
                            : narrow
                            ? 18
                            : 19,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: descriptionColor,
                        fontSize: compact ? 12 : 12.8,
                        fontWeight: FontWeight.w500,
                        height: 1.32,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: arrowBoxSize,
                height: arrowBoxSize,
                decoration: BoxDecoration(
                  color: isPrimary ? Colors.white : const Color(0xFFF5F8FA),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPrimary ? Colors.white : borderColor,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: arrowColor,
                  size: compact ? 19 : 21,
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

  const ChooseFeature({super.key, required this.icon, required this.label});

  static const Color teal = Color(0xFF005C7A);
  static const Color mutedText = Color(0xFF7A8790);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: teal, size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.35,
          ),
        ),
      ],
    );
  }
}

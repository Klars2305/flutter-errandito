import 'package:flutter/material.dart';

class OnboardingWalkthroughPage extends StatefulWidget {
  const OnboardingWalkthroughPage({super.key});

  @override
  State<OnboardingWalkthroughPage> createState() =>
      _OnboardingWalkthroughPageState();
}

class _OnboardingWalkthroughPageState extends State<OnboardingWalkthroughPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // REFERENCE-INSPIRED BLUE / TEAL PALETTE
  static const Color background = Color(0xFFF4F8F6);
  static const Color navy = Color(0xFF005C7A);

  final List<OnboardingItem> items = const [
    OnboardingItem(
      image: 'assets/images/onboarding_post_errand.png',
      title: 'Post errands easily',
      description:
          'Request help for food, parcels, laundry, printing, school needs, and everyday tasks in just a few taps.',
      imageWidthFactor: 1.02,
      imageOffsetY: 0,
    ),
    OnboardingItem(
      image: 'assets/images/onboarding_choose_service.png',
      title: 'Choose the right service',
      description:
          'Browse food, laundry, parcel, cleaning, school, and printing help, then match with a trusted runner.',
      imageWidthFactor: 0.88,
      imageOffsetY: -34,
    ),
    OnboardingItem(
      image: 'assets/images/onboarding_track_errand.png',
      title: 'Track every errand',
      description:
          'Get updates, chat with your runner, follow progress, and confirm completion smoothly.',
      imageWidthFactor: 0.96,
      imageOffsetY: -14,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == items.length - 1) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool shortScreen = screen.height < 740;
    final bool narrowScreen = screen.width < 390;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingScreenContent(
                      item: items[index],
                      currentIndex: _currentPage,
                      totalCount: items.length,
                      shortScreen: shortScreen,
                      narrowScreen: narrowScreen,
                      onNext: _next,
                    );
                  },
                ),

                Positioned(
                  top: 16,
                  right: 22,
                  child: TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: navy,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      _currentPage == items.length - 1 ? 'Done' : 'Skip',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreenContent extends StatelessWidget {
  final OnboardingItem item;
  final int currentIndex;
  final int totalCount;
  final bool shortScreen;
  final bool narrowScreen;
  final VoidCallback onNext;

  const OnboardingScreenContent({
    super.key,
    required this.item,
    required this.currentIndex,
    required this.totalCount,
    required this.shortScreen,
    required this.narrowScreen,
    required this.onNext,
  });

  // REFERENCE-INSPIRED BLUE / TEAL PALETTE
  static const Color navy = Color(0xFF005C7A);
  static const Color deepTeal = Color(0xFF004F68);
  static const Color teal = Color(0xFF006A8A);
  static const Color muted = Color(0xFF506272);
  static const Color background = Color(0xFFF4F8F6);
  static const Color softGreen = Color(0xFFE7F5F0);

  @override
  Widget build(BuildContext context) {
    final double imageTop = shortScreen ? 42 : 52;
    final double imageHeight = shortScreen ? 375 : 445;
    final double panelHeight = shortScreen ? 292 : 338;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [softGreen, background, teal.withOpacity(0.08)],
              ),
            ),
          ),
        ),

        Positioned(
          left: -90,
          top: 100,
          child: SoftCircle(size: 220, color: teal.withOpacity(0.08)),
        ),

        Positioned(
          right: -90,
          bottom: 82,
          child: SoftCircle(size: 235, color: deepTeal.withOpacity(0.07)),
        ),

        Positioned(
          top: imageTop,
          left: 0,
          right: 0,
          child: SizedBox(
            height: imageHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: narrowScreen ? 8 : 12),
              child: Transform.translate(
                offset: Offset(0, item.imageOffsetY),
                child: FractionallySizedBox(
                  widthFactor: item.imageWidthFactor,
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: navy,
                          size: 52,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: panelHeight,
            padding: EdgeInsets.fromLTRB(
              narrowScreen ? 26 : 34,
              shortScreen ? 34 : 42,
              narrowScreen ? 26 : 34,
              28,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(42),
              ),
              boxShadow: [
                BoxShadow(
                  color: navy.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, -12),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    fontSize: narrowScreen ? 30 : 32,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: muted,
                    fontSize: narrowScreen ? 15 : 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    letterSpacing: -0.1,
                  ),
                ),

                const Spacer(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OnboardingDots(
                      count: totalCount,
                      currentIndex: currentIndex,
                    ),

                    const Spacer(),

                    CleanOnboardingButton(
                      label: currentIndex == totalCount - 1 ? 'Start' : 'Next',
                      onTap: onNext,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CleanOnboardingButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CleanOnboardingButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  // REFERENCE-INSPIRED BLUE / TEAL PALETTE
  static const Color deepTeal = Color(0xFF004F68);
  static const Color teal = Color(0xFF006A8A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        constraints: const BoxConstraints(minWidth: 118),
        padding: const EdgeInsets.symmetric(horizontal: 34),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [deepTeal, teal],
          ),
          boxShadow: [
            BoxShadow(
              color: deepTeal.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class OnboardingDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingDots({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  // REFERENCE-INSPIRED BLUE / TEAL PALETTE
  static const Color teal = Color(0xFF006A8A);
  static const Color inactive = Color(0xFFE3ECE8);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final bool active = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(right: 12),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: active ? teal : inactive,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const SoftCircle({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;
  final double imageWidthFactor;
  final double imageOffsetY;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
    this.imageWidthFactor = 1.0,
    this.imageOffsetY = 0,
  });
}

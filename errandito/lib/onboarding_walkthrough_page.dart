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

  static const Color background = Color(0xFFF4F5F8);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color muted = Color(0xFF71787E);
  static const Color accent = Color(0xFFFFB84D);

  final List<OnboardingItem> items = const [
    OnboardingItem(
      icon: Icons.add_home_work_rounded,
      title: 'Post errands near you',
      description:
          'Need help with food, parcels, laundry, printing, or school needs? Create a request in just a few taps.',
    ),
    OnboardingItem(
      icon: Icons.delivery_dining_rounded,
      title: 'Choose a trusted runner',
      description:
          'ERRANDITO helps you connect with available runners who can handle your task safely and quickly.',
    ),
    OnboardingItem(
      icon: Icons.route_rounded,
      title: 'Track until it is done',
      description:
          'Chat, receive status updates, confirm delivery, and complete your errand smoothly from one app.',
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
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _previous() {
    if (_currentPage == 0) {
      Navigator.pop(context);
      return;
    }

    _controller.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool shortScreen = screen.height < 740;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 34,
              right: 42,
              child: SoftDot(size: 8, opacity: 0.55),
            ),
            const Positioned(
              left: 32,
              top: 154,
              child: SoftDot(size: 16, opacity: 0.35),
            ),
            const Positioned(
              right: 24,
              bottom: 112,
              child: SoftDot(size: 22, opacity: 0.35),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
                  child: Container(
                    width: double.infinity,
                    height: shortScreen ? 600 : 660,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 34,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _previous,
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 18,
                                    color: navy,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: _skip,
                                  child: Text(
                                    _currentPage == items.length - 1
                                        ? 'DONE'
                                        : 'SKIP',
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: items.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return OnboardingSlide(
                                  item: items[index],
                                  shortScreen: shortScreen,
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(28, 0, 28, 22),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: _skip,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    _currentPage == items.length - 1
                                        ? 'DONE'
                                        : 'SKIP',
                                    style: const TextStyle(
                                      color: muted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                OnboardingDots(
                                  count: items.length,
                                  currentIndex: _currentPage,
                                ),

                                const Spacer(),

                                Material(
                                  color: accent,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    onTap: _next,
                                    customBorder: const CircleBorder(),
                                    child: const SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
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
          ],
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingItem item;
  final bool shortScreen;

  const OnboardingSlide({
    super.key,
    required this.item,
    required this.shortScreen,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color muted = Color(0xFF71787E);
  static const Color softYellow = Color(0xFFFFF4C8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 6, 28, 0),
      child: Column(
        children: [
          SizedBox(height: shortScreen ? 18 : 34),

          SizedBox(
            height: shortScreen ? 230 : 275,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: shortScreen ? 168 : 200,
                  height: shortScreen ? 168 : 200,
                  decoration: const BoxDecoration(
                    color: softYellow,
                    shape: BoxShape.circle,
                  ),
                ),

                Positioned(
                  top: shortScreen ? 16 : 28,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: navy.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(item.icon, color: teal, size: 31),
                  ),
                ),

                Positioned(
                  bottom: shortScreen ? 18 : 26,
                  child: ErrandIllustration(icon: item.icon),
                ),
              ],
            ),
          ),

          SizedBox(height: shortScreen ? 18 : 26),

          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 12.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrandIllustration extends StatelessWidget {
  final IconData icon;

  const ErrandIllustration({super.key, required this.icon});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color accent = Color(0xFFFFB84D);

  @override
  Widget build(BuildContext context) {
    if (icon == Icons.add_home_work_rounded) {
      return SizedBox(
        width: 150,
        height: 135,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 104,
              height: 84,
              decoration: BoxDecoration(
                color: teal.withOpacity(0.86),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              top: 24,
              child: Icon(Icons.location_on_rounded, color: accent, size: 54),
            ),
            Positioned(
              bottom: 22,
              child: Container(
                width: 28,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              right: 42,
              child: Icon(
                Icons.window_rounded,
                color: Colors.white.withOpacity(0.82),
                size: 20,
              ),
            ),
          ],
        ),
      );
    }

    if (icon == Icons.delivery_dining_rounded) {
      return SizedBox(
        width: 170,
        height: 130,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 22,
              child: Icon(
                Icons.delivery_dining_rounded,
                color: teal,
                size: 104,
              ),
            ),
            Positioned(
              top: 6,
              left: 38,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 162,
      height: 134,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 82,
            height: 126,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: navy.withOpacity(0.18), width: 2),
              boxShadow: [
                BoxShadow(
                  color: navy.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            child: Container(
              width: 48,
              height: 8,
              decoration: BoxDecoration(
                color: teal.withOpacity(0.22),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            top: 48,
            child: Container(
              width: 48,
              height: 8,
              decoration: BoxDecoration(
                color: teal.withOpacity(0.22),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Icon(Icons.route_rounded, color: teal, size: 42),
          ),
          Positioned(
            left: 18,
            top: 38,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.navigation_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ],
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

  static const Color accent = Color(0xFFFFB84D);
  static const Color inactive = Color(0xFFD8DDE3);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final bool active = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 5,
          height: 5,
          decoration: BoxDecoration(
            color: active ? accent : inactive,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class SoftDot extends StatelessWidget {
  final double size;
  final double opacity;

  const SoftDot({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

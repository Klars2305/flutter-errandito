import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color green = Color(0xFF004035);
  static const Color borderColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    final bool isNarrow = MediaQuery.of(context).size.width <= 390;
    final bool twoColumns = MediaQuery.of(context).size.width >= 420;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pushNamed(context, '/servicehub');
                              },
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: navy,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Hi, Bronny',
                            style: TextStyle(
                              color: navy,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F3F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: navy,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 40,
                              height: 40,
                              color: const Color(0xFFE1E2E6),
                              child: Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: navy,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      isNarrow ? 16 : 24,
                      16,
                      isNarrow ? 16 : 24,
                      140,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book a Service',
                              style: TextStyle(
                                color: navy,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.75,
                              ),
                            ),
                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F3F7),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: teal,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          blurRadius: 15,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.10),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_shipping,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Grocery Delivery & Sorting',
                                          style: TextStyle(
                                            color: navy,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            height: 1.4,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Professional stewardship for your household essentials.',
                                          style: TextStyle(
                                            color: bodyText,
                                            fontSize: 14,
                                            height: 1.42,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            const SectionHeader(
                              icon: Icons.location_on,
                              title: 'Service Location',
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter delivery address...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.fromLTRB(
                                  18,
                                  18,
                                  48,
                                  18,
                                ),
                                suffixIcon: const Icon(
                                  Icons.my_location,
                                  color: Color(0xFF94A3B8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: navy,
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              height: 256,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFFECEEF1),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                    spreadRadius: -1,
                                  ),
                                ],
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/map_pins.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFECEEF1),
                                        child: const Center(
                                          child: Icon(
                                            Icons.map_outlined,
                                            color: Color(0xFF94A3B8),
                                            size: 64,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Center(
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: navy,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.30),
                                            blurRadius: 4,
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 50,
                                            offset: const Offset(0, 25),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            if (twoColumns)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Expanded(child: DateBlock()),
                                  SizedBox(width: 16),
                                  Expanded(child: TimeBlock()),
                                ],
                              )
                            else
                              const Column(
                                children: [
                                  DateBlock(),
                                  SizedBox(height: 16),
                                  TimeBlock(),
                                ],
                              ),

                            const SizedBox(height: 18),

                            const SectionHeader(
                              icon: Icons.notes,
                              title: 'Specific Instructions',
                            ),
                            const SizedBox(height: 12),

                            TextField(
                              minLines: 5,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText:
                                    'Any gate codes, fridge organization preferences, or specific brand requests...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF2F3F7),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFD8DADD).withOpacity(0.30),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user,
                                    color: green,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'All stewards are background- checked & insured',
                                      style: TextStyle(
                                        color: bodyText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 1.33,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE1E2E6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'i',
                                        style: TextStyle(
                                          color: Color(0xFF536167),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
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
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                isNarrow ? 16 : 24,
                18,
                isNarrow ? 16 : 24,
                18,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.80),
                boxShadow: [
                  BoxShadow(
                    color: darkText.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 25,
                            offset: const Offset(0, 20),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pushNamed(context, '/select-helper');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue to Helpers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 1.55,
                                  ),
                                ),
                                SizedBox(width: 12),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: navy,
          size: 22,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class DateBlock extends StatelessWidget {
  const DateBlock({super.key});

  static const Color darkText = Color(0xFF191C1E);
  static const Color borderColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.calendar_month,
          title: 'Preferred Date',
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: const Text(
            'mm / dd / yyyy',
            style: TextStyle(
              color: darkText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class TimeBlock extends StatelessWidget {
  const TimeBlock({super.key});

  static const Color darkText = Color(0xFF191C1E);
  static const Color borderColor = Color(0xFFC0C7CE);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.access_time_filled,
          title: 'Time Slot',
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Morning (8 AM - 12 PM)',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

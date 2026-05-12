import 'package:flutter/material.dart';

class SelectHelperPage extends StatelessWidget {
  const SelectHelperPage({super.key});

  static const Color background = Color(0xFFF8F9FD);
  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color darkText = Color(0xFF191C1E);
  static const Color bodyText = Color(0xFF40484E);
  static const Color mutedBadge = Color(0xFF58676D);
  static const Color green = Color(0xFF17584C);
  static const Color premiumGreen = Color(0xFFB1EFDE);

  static const List<HelperModel> helpers = [
    HelperModel(
      name: 'Zhandro Diacor',
      role: 'Logistics & Tech Support',
      rating: '4.9',
      done: '128 errands completed',
      eta: '8 - 12 mins away',
      image: 'assets/images/helper.png',
      tags: ['Quick Errands', 'Tech Setup', 'Priority'],
    ),
    HelperModel(
      name: 'Jamaica Masinapoc',
      role: 'Fine Dining & Event Curation',
      rating: '5.0',
      done: '94 errands completed',
      eta: '15 - 20 mins away',
      image: 'assets/images/helper_female.png',
      tags: ['Catering', 'Gifting', 'Luxury'],
    ),
    HelperModel(
      name: 'Jerlyn Corpuz',
      role: 'Home Management & Pet Care',
      rating: '4.8',
      done: '210 errands completed',
      eta: '5 mins away',
      image: 'assets/images/jerlyn.png',
      tags: ['House Sitting', 'Pet Support'],
    ),
    HelperModel(
      name: 'Christian Misal',
      role: 'Shopping & Heavy Lifting',
      rating: '4.7',
      done: '340 errands completed',
      eta: '25 mins away',
      image: 'assets/images/christian.png',
      tags: ['Bulk Grocery', 'Furniture'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void goToReviewPay() {
      Navigator.pushNamed(context, '/reviewpay');
    }

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFD6E5EC),
                            child: const Icon(
                              Icons.person,
                              color: navy,
                            ),
                          );
                        },
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
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6E5EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'AVAILABLE NOW',
                            style: TextStyle(
                              color: mutedBadge,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.96,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Select Your Runner',
                          style: TextStyle(
                            color: navy,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            height: 1.11,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Every Digital Concierge is vetted for precision and reliability. Choose the specialist that matches your mission.',
                          style: TextStyle(
                            color: bodyText,
                            fontSize: 18,
                            height: 1.55,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                child: TabButton(
                                  label: 'Nearby',
                                  active: true,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TabButton(
                                  label: 'Top Rated',
                                  active: false,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        HelperCard(
                          helper: helpers[0],
                          onBook: goToReviewPay,
                        ),

                        const SizedBox(height: 16),

                        HelperCard(
                          helper: helpers[1],
                          onBook: goToReviewPay,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'PREMIUM RUNNER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 1.56,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.20),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.asset(
                                    'assets/images/steward.png',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFFD6E5EC),
                                        child: const Icon(
                                          Icons.person,
                                          color: navy,
                                          size: 56,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Klarence Degracia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Confidential & Executive Assistance',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF8BC7EF),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: const [
                                  Expanded(
                                    child: PremiumStat(
                                      label: 'Success Rate',
                                      value: '100%',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: PremiumStat(
                                      label: 'Arrival',
                                      value: 'Ready',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: goToReviewPay,
                                    child: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Text(
                                        'Book Klarence Now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: navy,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        HelperCard(
                          helper: helpers[2],
                          onBook: goToReviewPay,
                        ),

                        const SizedBox(height: 16),

                        HelperCard(
                          helper: helpers[3],
                          onBook: goToReviewPay,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Custom Request?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Don't see the right match? Describe your task and our algorithm will pair you with an available Steward within 60 seconds.",
                                style: TextStyle(
                                  color: Color(0xFF95D3C3),
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: Material(
                                  color: premiumGreen,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: goToReviewPay,
                                    child: const Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Text(
                                        'Start Custom Search',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF00201A),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
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
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;
  final bool active;

  const TabButton({
    super.key,
    required this.label,
    required this.active,
  });

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: active ? navy : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: active ? Colors.white : navy,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class HelperCard extends StatelessWidget {
  final HelperModel helper;
  final VoidCallback onBook;

  const HelperCard({
    super.key,
    required this.helper,
    required this.onBook,
  });

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color bodyText = Color(0xFF40484E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    helper.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFD6E5EC),
                        child: const Icon(
                          Icons.person,
                          color: navy,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    helper.rating,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    helper.done,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: bodyText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            helper.name,
            style: const TextStyle(
              color: navy,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            helper.role,
            style: const TextStyle(
              color: bodyText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: helper.tags.map((tag) {
              final bool isPriority = tag == 'Priority';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPriority
                      ? const Color(0xFFB1EFDE)
                      : const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color:
                        isPriority ? const Color(0xFF00201A) : navy,
                    fontSize: 12,
                    fontWeight:
                        isPriority ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.only(top: 18),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFECEEF1),
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    helper.eta,
                    style: const TextStyle(
                      color: Color(0xFF191C1E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          navy,
                          teal,
                        ],
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onBook,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumStat extends StatelessWidget {
  final String label;
  final String value;

  const PremiumStat({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class HelperModel {
  final String name;
  final String role;
  final String rating;
  final String done;
  final String eta;
  final String image;
  final List<String> tags;

  const HelperModel({
    required this.name,
    required this.role,
    required this.rating,
    required this.done,
    required this.eta,
    required this.image,
    required this.tags,
  });
}

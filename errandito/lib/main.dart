import 'package:flutter/material.dart';
import 'account_created.dart';
import 'activity_planner.dart';
import 'booking_details.dart';
import 'choose_page.dart';
import 'coordination_page.dart';
import 'errand_execution_payment.dart';
import 'execution_messaging_page.dart';
import 'execution_status_page.dart';
import 'gig_finder_page.dart';
import 'grocery_pickup_details_page.dart';
import 'home_dashboard_page.dart';
import 'identity_verification_page.dart';
import 'live_tracking_page.dart';
import 'login_screen_page.dart';
import 'messages_page.dart';
import 'onboarding_walkthrough_page.dart';
import 'payment_earnings_page.dart';
import 'payment_secured_page.dart';
import 'review_pay_page.dart';
import 'select_helper_page.dart';
import 'sign_up_screen_page.dart';
import 'steward_wallet_budget_allocated_page.dart';
import 'task_complete_page.dart';

void main() {
  runApp(const ErrandditoApp());
}

class ErrandditoApp extends StatelessWidget {
  const ErrandditoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Erranddito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AestheticSplashScreen(),
        '/onboarding': (context) => const OnboardingWalkthroughPage(),
        '/choose': (context) => const ChoosePage(),
        '/login': (context) => const LoginScreenPage(),
        '/signup': (context) => const SignUpScreenPage(),
        '/identity': (context) => const IdentityVerificationPage(),
        '/create-account': (context) => const HomeDashboardPage(),
        '/account-created': (context) => const AccountCreatedPage(),
        '/profile': (context) => const AccountCreatedPage(),
        '/home-dashboard': (context) => const HomeDashboardPage(),
        '/servicehub': (context) => const BookingDetailsPage(),
        '/bookingdetails': (context) => const BookingDetailsPage(),
        '/select-helper': (context) => const SelectHelperPage(),
        '/reviewpay': (context) => const ReviewPayPage(),
        '/payment': (context) => const PaymentSecuredPage(),
        '/payment-earnings': (context) => const PaymentEarningsPage(),
        '/message': (context) => const MessagesPage(),
        '/coordination': (context) => const CoordinationChatPage(),
        '/live-tracking': (context) => const LiveTrackingPage(),
        '/task-complete': (context) => const TaskCompletePage(),
        '/gig-finder': (context) => const GigFinderJobListingsPage(),
        '/execution-status': (context) => const ExecutionStatusUpdatePage(),
        '/execution-messaging': (context) => const ExecutionMessagingPage(),
        '/task-complete-earnings': (context) => const PaymentEarningsPage(),
        '/activity-planner': (context) => const ActivityPlannerPage(),
        '/activity': (context) => const ActivityPlannerPage(),
        '/steward-wallet-budget-allocated': (context) => const StewardWalletBudgetAllocatedPage(),
        '/errand-execution-payment': (context) => const ErrandExecutionPaymentPage(),
        '/steward-execution-completed': (context) => const ErrandExecutionPaymentPage(),
        '/grocery-pickup-details': (context) => const GroceryPickupDetailsPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const AestheticSplashScreen(),
        );
      },
    );
  }
}

class AestheticSplashScreen extends StatelessWidget {
  const AestheticSplashScreen({super.key});

  static const Color navy = Color(0xFF003C56);
  static const Color teal = Color(0xFF005477);
  static const Color background = Color(0xFFF8F9FD);
  static const Color mutedText = Color(0xFF71787E);
  static const Color darkGreen = Color(0xFF004035);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: background,
            ),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      background,
                      background.withOpacity(0.0),
                      navy.withOpacity(0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              left: -96,
              top: -96,
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  color: const Color(0xFF92CEF6).withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            Positioned(
              right: -96,
              bottom: 122,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: const Color(0xFF95D3C3).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            Positioned(
              left: 132,
              top: 333,
              child: Container(
                width: size.width,
                height: 1,
                color: navy.withOpacity(0.05),
              ),
            ),

            Positioned(
              left: -91,
              top: 539,
              child: Container(
                width: size.width,
                height: 1,
                color: navy.withOpacity(0.05),
              ),
            ),

            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 72),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 32,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Elite Concierge',
                          style: TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                            letterSpacing: 4.2,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 128,
                          child: Image.asset(
                            'assets/images/ErrandditoLogo.png',
                            width: 269,
                            height: 179,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1,
                              color: const Color(0xFFC0C7CE).withOpacity(0.40),
                            ),
                            const SizedBox(width: 16),
                            const Flexible(
                              child: Text(
                                'Pagod ka na? erranddito na!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 40,
                              height: 1,
                              color: const Color(0xFFC0C7CE).withOpacity(0.40),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Container(
                          width: 96,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                teal.withOpacity(0),
                                teal,
                                teal.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const SplashProgressIndicator(),

                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 448),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                    color:
                                        const Color(0xFF191C1E).withOpacity(0.12),
                                    offset: const Offset(0, 24),
                                    blurRadius: 48,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 326,
                                      height: 64,
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/onboarding',
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Get Started',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                height: 1.5,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FeatureText(label: 'Precision'),
                            SizedBox(width: 40),
                            FeatureText(label: 'Trust'),
                            SizedBox(width: 40),
                            FeatureText(label: 'Speed'),
                          ],
                        ),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            IgnorePointer(
              child: Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: background,
                      width: 32,
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

class SplashProgressIndicator extends StatelessWidget {
  const SplashProgressIndicator({super.key});

  static const Color navy = Color(0xFF003C56);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: navy.withOpacity(0.20),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 4,
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: navy.withOpacity(0.20),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class FeatureText extends StatelessWidget {
  final String label;

  const FeatureText({
    super.key,
    required this.label,
  });

  static const Color mutedText = Color(0xFF71787E);
  static const Color darkGreen = Color(0xFF004035);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: darkGreen,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF003C56),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF003C56),
        ),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF003C56),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

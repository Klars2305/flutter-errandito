import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// main.dart
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_core/firebase_core.dart';
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
import 'messages_page.dart' as messages;
import 'onboarding_walkthrough_page.dart';
import 'payment_earnings_page.dart';
import 'payment_secured_page.dart';
import 'review_pay_page.dart';
import 'select_helper_page.dart';
import 'sign_up_screen_page.dart';
import 'steward_wallet_budget_allocated_page.dart';
import 'task_complete_page.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        // Splash / Start
        '/': (context) => const AestheticSplashScreen(),
        '/splash': (context) => const AestheticSplashScreen(),

        // Onboarding / Authentication
        '/onboarding': (context) => const OnboardingWalkthroughPage(),
        '/login': (context) => const LoginScreenPage(),
        '/signin': (context) => const LoginScreenPage(),
        '/signup': (context) => const SignUpScreenPage(),
        '/sign-up': (context) => const SignUpScreenPage(),

        // Role / Verification
        '/choose': (context) => const ChoosePage(),
        '/role-selection': (context) => const ChoosePage(),

        // IMPORTANT:
        // No const here because your IdentityVerificationPage is not const.
        '/identity': (context) => IdentityVerificationPage(),
        '/identity-verification': (context) => IdentityVerificationPage(),
        '/verification': (context) => IdentityVerificationPage(),

        // Account / Profile
        '/create-account': (context) => const HomeDashboardPage(),
        '/account-created': (context) => const AccountCreatedPage(),
        '/profile': (context) => const AccountCreatedPage(),
        '/account': (context) => const AccountCreatedPage(),

        // Requester Home
        '/home': (context) => const HomeDashboardPage(),
        '/home-dashboard': (context) => const HomeDashboardPage(),
        '/requester-home': (context) => const HomeDashboardPage(),
        '/requester-dashboard': (context) => const HomeDashboardPage(),

        // Requester Flow
        '/servicehub': (context) => const BookingDetailsPage(),
        '/bookingdetails': (context) => const BookingDetailsPage(),
        '/booking-details': (context) => const BookingDetailsPage(),
        '/task-details': (context) => const BookingDetailsPage(),

        '/select-helper': (context) => const SelectHelperPage(),
        '/reviewpay': (context) => const ReviewPayPage(),
        '/review-pay': (context) => const ReviewPayPage(),
        '/ratings': (context) => const ReviewPayPage(),
        '/review': (context) => const ReviewPayPage(),

        '/payment': (context) => const PaymentSecuredPage(),
        '/payment-secured': (context) => const PaymentSecuredPage(),
        '/payment-earnings': (context) => const PaymentEarningsPage(),

        // Messaging
        // IMPORTANT:
        // Use messages.MessagesPage() because MessagesPage name conflicts
        // with another imported file.
        '/message': (context) => const messages.MessagesPage(),
        '/messages': (context) => const messages.MessagesPage(),
        '/runner-message': (context) => const CoordinationPage(),
        '/runner-messages': (context) => const CoordinationPage(),
        '/chat': (context) => const messages.MessagesPage(),

        // Tracking / Completion
        '/live-tracking': (context) => const LiveTrackingPage(),
        '/task-tracking': (context) => const LiveTrackingPage(),
        '/task-complete': (context) => const TaskCompletePage(),
        '/completed-task': (context) => const TaskCompletePage(),

        // Runner Flow
        '/gig-finder': (context) => const GigFinderJobListingsPage(),
        '/runner-home': (context) => const ActivityPlannerPage(),
        '/runner-dashboard': (context) => const ActivityPlannerPage(),
        '/available-errands': (context) => const GigFinderJobListingsPage(),

        '/execution-status': (context) => const ExecutionStatusUpdatePage(),
        '/status-update': (context) => const ExecutionStatusUpdatePage(),
        '/execution-messaging': (context) => const ExecutionMessagingPage(),
        '/task-chat': (context) => const ExecutionMessagingPage(),
        '/task-complete-earnings': (context) => const PaymentEarningsPage(),

        // Post Errand / Activity
        '/activity-planner': (context) => const ActivityPlannerPage(),
        '/post-errand': (context) => const ActivityPlannerPage(),

        // Keeping your old activity route working
        '/activity': (context) => const LiveTrackingPage(),

        // Payment / Wallet
        '/runner-profile': (context) =>
            const StewardWalletBudgetAllocatedPage(),
        '/steward-profile': (context) =>
            const StewardWalletBudgetAllocatedPage(),
        '/steward-wallet-budget-allocated': (context) =>
            const StewardWalletBudgetAllocatedPage(),
        '/errand-execution-payment': (context) =>
            const ErrandExecutionPaymentPage(),
        '/payment-summary': (context) => const ErrandExecutionPaymentPage(),
        '/steward-execution-completed': (context) =>
            const ErrandExecutionPaymentPage(),

        // Details
        '/grocery-pickup-details': (context) =>
            const GroceryPickupDetailsPage(),
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

  // REFERENCE-INSPIRED BLUE / TEAL PALETTE
  static const Color background = Color(0xFFF4F8F6);

  static const Color navy = Color(0xFF005C7A);
  static const Color teal = Color(0xFF007A8A);

  static const Color darkGreen = Color(0xFF004F68);
  static const Color primaryGreen = Color(0xFF006A8A);
  static const Color softGreen = Color(0xFFE7F5F0);

  static const Color mutedText = Color(0xFF506272);
  static const Color inactive = Color(0xFF9AA8A3);
  static const Color borderColor = Color(0xFFE3ECE8);

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool narrow = screen.width < 390;
    final bool short = screen.height < 760;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/errandito_logo.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: softGreen,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: darkGreen,
                    size: 56,
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    background.withOpacity(0.88),
                    background,
                  ],
                  stops: const [0.0, 0.48, 0.72, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                narrow ? 24 : 32,
                16,
                narrow ? 24 : 32,
                short ? 22 : 30,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  Text(
                    'WELCOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: narrow ? 32 : 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Pagod ka na ba? Errandito na!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy.withOpacity(0.94),
                      fontSize: narrow ? 13.5 : 14.5,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Errandito helps you with delivery, laundry,\ncleaning, tutoring, printing, and everyday errands.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: mutedText,
                      fontSize: narrow ? 12 : 13,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),

                  SizedBox(height: short ? 22 : 28),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [darkGreen, primaryGreen],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withOpacity(0.20),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/onboarding',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

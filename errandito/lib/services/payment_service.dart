import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  PaymentService._();

  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  static String _friendlyFunctionsError(Object error) {
    if (error is FirebaseFunctionsException) {
      final message = error.message;
      if (message != null && message.trim().isNotEmpty) {
        return message.trim();
      }
      return '${error.code}: ${error.details ?? 'Firebase Function failed'}';
    }
    return error.toString();
  }

  static Future<void> startHitPayCheckout({
    required String errandId,
  }) async {
    try {
      final callable = _functions.httpsCallable('createHitPayPayment');

      final result = await callable.call({
        'errandId': errandId,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      final checkoutUrl = (data['checkoutUrl'] ?? '').toString();

      if (checkoutUrl.isEmpty) {
        throw Exception('No HitPay checkout URL returned.');
      }

      final uri = Uri.parse(checkoutUrl);

      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        throw Exception('Could not open HitPay checkout.');
      }
    } catch (error) {
      throw Exception(_friendlyFunctionsError(error));
    }
  }

  static Future<String> checkHitPayPaymentStatus({
    required String errandId,
  }) async {
    try {
      final callable = _functions.httpsCallable('checkHitPayPaymentStatus');

      final result = await callable.call({
        'errandId': errandId,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      return (data['paymentStatus'] ?? 'pending').toString();
    } catch (error) {
      throw Exception(_friendlyFunctionsError(error));
    }
  }
}

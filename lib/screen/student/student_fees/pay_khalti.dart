import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PayKhalti extends StatefulWidget {
  const PayKhalti({super.key});

  @override
  State<PayKhalti> createState() => _PayKhaltiState();
}

class _PayKhaltiState extends State<PayKhalti> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        payWithKhalti(context);
      },
      icon: const Icon(Icons.payment, color: Colors.white),
      label: const Text(
        'Pay with Khalti',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  void payWithKhalti(BuildContext context) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 10000,
        productIdentity: 'product_${DateTime.now().millisecondsSinceEpoch}',
        productName: 'Product Fee',
      ),
      onSuccess: (PaymentSuccessModel success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Successful! Token: ${success.token}'),
          ),
        );
      },
      onFailure: (PaymentFailureModel failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed: ${failure.message}'),
          ),
        );
      },
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Cancelled')),
        );
      },
    );
  }
}
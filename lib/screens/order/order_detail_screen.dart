import 'package:flutter/material.dart';
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Order Details')), body: Center(child: Text('Order ID: $orderId')));
}

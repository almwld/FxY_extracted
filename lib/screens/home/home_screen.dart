import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Flex Yemen', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text('منصة التجارة الإلكترونية اليمنية'),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () {}, child: const Text('تسوق الآن')),
      ]),
    ),
  );
}

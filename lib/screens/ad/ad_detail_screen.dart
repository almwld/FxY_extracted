import 'package:flutter/material.dart';
class AdDetailScreen extends StatelessWidget {
  final String adId;
  const AdDetailScreen({super.key, required this.adId});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Ad Details')), body: Center(child: Text('Ad ID: $adId')));
}

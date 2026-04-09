import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
class ErrorState extends StatelessWidget {
  final String message; final VoidCallback? onRetry;
  const ErrorState({super.key, required this.message, this.onRetry});
  @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error_outline, size: 80, color: Colors.red), const SizedBox(height: 16), Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)), if (onRetry != null) ...[const SizedBox(height: 24), ElevatedButton(onPressed: onRetry, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldColor), child: const Text('إعادة المحاولة'))]]));
}

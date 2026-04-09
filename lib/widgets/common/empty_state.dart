import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
class EmptyState extends StatelessWidget {
  final String message; final String? subMessage; final IconData? icon; final VoidCallback? onAction; final String? actionLabel;
  const EmptyState({super.key, required this.message, this.subMessage, this.icon, this.onAction, this.actionLabel});
  @override Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon ?? Icons.inbox, size: 80, color: Colors.grey), const SizedBox(height: 16), Text(message, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), if (subMessage != null) ...[const SizedBox(height: 8), Text(subMessage!, style: TextStyle(color: Colors.grey))], if (onAction != null && actionLabel != null) ...[const SizedBox(height: 24), ElevatedButton(onPressed: onAction, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldColor), child: Text(actionLabel!))]])); }

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// رأس القسم
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  Text(
                    actionText ?? 'عرض الكل',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.goldColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.goldColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

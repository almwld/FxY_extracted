import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor ?? AppTheme.goldColor,
      foregroundColor: Colors.black,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/theme_provider.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        children: [
          // المظهر
          _buildSectionTitle('المظهر'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text(AppStrings.theme),
            subtitle: Text(
              themeProvider.isDarkMode ? 'داكن' : 'فاتح',
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                if (value) {
                  themeProvider.setDarkMode();
                } else {
                  themeProvider.setLightMode();
                }
              },
              activeColor: AppColors.goldColor,
            ),
          ),
          
          // اللغة
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text(AppStrings.language),
            subtitle: const Text('العربية'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.language);
            },
          ),
          
          const Divider(),
          
          // الإشعارات
          _buildSectionTitle('الإشعارات'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('إشعارات Push'),
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.goldColor,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text('إشعارات البريد الإلكتروني'),
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.goldColor,
          ),
          
          const Divider(),
          
          // الأمان
          _buildSectionTitle('الأمان'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('تغيير كلمة المرور'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.changePassword);
            },
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('المصادقة البيومترية'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.biometric);
            },
          ),
          
          const Divider(),
          
          // القانوني
          _buildSectionTitle('قانوني'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text(AppStrings.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.privacyPolicy);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text(AppStrings.terms),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.terms);
            },
          ),
          
          const Divider(),
          
          // حول
          _buildSectionTitle('حول'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.about),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.about);
            },
          ),
          
          const SizedBox(height: 24),
          
          // الإصدار
          Center(
            child: Text(
              'الإصدار 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

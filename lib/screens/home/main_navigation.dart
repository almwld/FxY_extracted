import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import 'home_screen.dart';
import '../all_ads_screen.dart';
import '../map/interactive_map_screen.dart';
import '../wallet/wallet_screen.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../add_ad_screen.dart';
import '../seller_products_screen.dart';
import '../request_service_screen.dart';
import '../receive_transfer_request_screen.dart';
import '../ai_assistant_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _isExpanded = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    AllAdsScreen(),
    InteractiveMapScreen(),
    WalletScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.add_circle_outline, 'label': 'إضافة إعلان', 'color': 0xFF4CAF50, 'screen': AddAdScreen()},
    {'icon': Icons.shopping_bag_outlined, 'label': 'إضافة منتج', 'color': 0xFF2196F3, 'screen': SellerProductsScreen()},
    {'icon': Icons.handyman_outlined, 'label': 'طلب خدمة', 'color': 0xFFFF9800, 'screen': RequestServiceScreen()},
    {'icon': Icons.account_balance_wallet_outlined, 'label': 'استلام حوالة', 'color': 0xFF9C27B0, 'screen': ReceiveTransferRequestScreen()},
  ];

  void _onItemTapped(int index) {
    if (index == 3) {  // الزر الذهبي في المنتصف (الترتيب 3)
      setState(() => _isExpanded = !_isExpanded);
      return;
    }
    // إعادة ترتيب المؤشرات لأن الزر الذهبي لا يحسب في _screens
    final int screenIndex = index > 3 ? index - 1 : index;
    setState(() {
      _currentIndex = screenIndex;
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('فلكس يمن', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.goldColor,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIAssistantScreen())),
            tooltip: 'المساعد الذكي',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            tooltip: 'السلة',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            tooltip: 'الإشعارات',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 7 أزرار - الزر الذهبي في المنتصف (الترتيب 4)
                _buildNavItem('assets/icons/svg/home.svg', 'الرئيسية', 0),
                _buildNavItem('assets/icons/svg/merchant.svg', 'المتجر', 1),
                _buildNavItem('assets/icons/svg/location.svg', 'الخريطة', 2),
                _buildGoldenButton(),  // الزر الذهبي في المنتصف
                _buildNavItem('assets/icons/svg/wallet.svg', 'المحفظة', 4),
                _buildNavItem('assets/icons/svg/chat.svg', 'الدردشة', 5),
                _buildNavItem('assets/icons/svg/profile.svg', 'حسابي', 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String svgPath, String label, int index) {
    // تحويل المؤشر لأن الزر الذهبي في المنتصف
    final int actualIndex = index > 3 ? index - 1 : index;
    final bool isSelected = _currentIndex == actualIndex;
    final Color color = isSelected ? AppTheme.goldColor : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgPath, width: 24, height: 24, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldenButton() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (_isExpanded)
            Positioned(
              bottom: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
                ),
                child: Row(
                  children: _quickActions.asMap().entries.map((entry) {
                    final action = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _isExpanded = false);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => action['screen']));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(action['color']).withOpacity(0.2),
                                border: Border.all(color: Color(action['color']), width: 2),
                              ),
                              child: Icon(action['icon'], color: Color(action['color']), size: 22),
                            ),
                            const SizedBox(height: 4),
                            Text(action['label'], style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppTheme.goldColor, AppTheme.goldDark]),
                boxShadow: [BoxShadow(color: AppTheme.goldColor.withOpacity(0.5), blurRadius: 20)],
              ),
              child: Icon(_isExpanded ? Icons.close : Icons.add, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

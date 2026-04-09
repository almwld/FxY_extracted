import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';
import '../product/products_screen.dart';
import '../wallet/wallet_screen.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';

/// الشريط السفلي الرئيسي
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductsScreen(),
    const WalletScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final List<String> _labels = [
    'الرئيسية',
    'المنتجات',
    'المحفظة',
    'المحادثات',
    'حسابي',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.shopping_bag_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  final List<IconData> _activeIcons = [
    Icons.home,
    Icons.shopping_bag,
    Icons.account_balance_wallet,
    Icons.chat_bubble,
    Icons.person,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.goldColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? _activeIcons[index] : _icons[index],
                          color: isSelected
                              ? AppColors.goldColor
                              : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.goldColor
                                : Colors.grey,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

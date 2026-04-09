import 'package:flutter/material.dart';
import 'home_screen.dart';
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override State<MainNavigation> createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [HomeScreen(), Center(child: Text('المتجر')), Center(child: Text('المحفظة')), Center(child: Text('حسابي'))];
  @override Widget build(BuildContext context) => Scaffold(
    body: _screens[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFD4AF37),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'المتجر'),
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'المحفظة'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
      ],
    ),
  );
}

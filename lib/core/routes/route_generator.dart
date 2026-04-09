import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/main_navigation.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
    }
  }
}

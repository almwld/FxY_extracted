import 'package:flutter/material.dart';

/// أدوات التنقل
class NavigationUtils {
  NavigationUtils._();

  /// الانتقال إلى صفحة جديدة
  static Future<T?> push<T>(
    BuildContext context,
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  /// الانتقال إلى صفحة جديدة وإزالة الصفحات السابقة
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }

  /// الانتقال إلى صفحة جديدة واستبدال الصفحة الحالية
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// العودة إلى الصفحة السابقة
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// العودة إلى الصفحة المحددة
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// التحقق مما إذا كان يمكن العودة
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// الانتقال بالاسم
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// الانتقال بالاسم واستبدال الصفحة الحالية
  static Future<T?> pushReplacementNamed<T, TO>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// الانتقال بالاسم وإزالة الصفحات السابقة
  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// الانتقال مع تأثير التلاشي
  static Future<T?> pushWithFade<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: duration,
      ),
    );
  }

  /// الانتقال مع تأثير الانزلاق
  static Future<T?> pushWithSlide<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    SlideDirection direction = SlideDirection.right,
  }) {
    Offset begin;
    switch (direction) {
      case SlideDirection.right:
        begin = const Offset(1, 0);
        break;
      case SlideDirection.left:
        begin = const Offset(-1, 0);
        break;
      case SlideDirection.up:
        begin = const Offset(0, 1);
        break;
      case SlideDirection.down:
        begin = const Offset(0, -1);
        break;
    }

    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: begin, end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: duration,
      ),
    );
  }

  /// الانتقال مع تأثير التكبير
  static Future<T?> pushWithScale<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut));
          return ScaleTransition(
            scale: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: duration,
      ),
    );
  }

  /// عرض Bottom Sheet
  static Future<T?> showBottomSheet<T>(
    BuildContext context,
    Widget sheet, {
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    ShapeBorder? shape,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (_) => sheet,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: backgroundColor,
    );
  }

  /// عرض Dialog
  static Future<T?> showDialog<T>(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useRootNavigator = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
    );
  }

  /// عرض SnackBar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// إخفاء SnackBar
  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// عرض Loading
  static void showLoading(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? 'جاري التحميل...'),
            ],
          ),
        ),
      ),
    );
  }

  /// إخفاء Loading
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// الحصول على حجم الشاشة
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// الحصول على ارتفاع الشاشة
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// الحصول على عرض الشاشة
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// الحصول على padding الأعلى
  static double getTopPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// الحصول على padding الأسفل
  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// التحقق من اتجاه الشاشة
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// التحقق مما إذا كان الجهاز لوحي
  static bool isTablet(BuildContext context) {
    final size = getScreenSize(context);
    final diagonal = (size.width * size.width + size.height * size.height);
    return diagonal > 15000000; // تقريباً 7 بوصة
  }
}

/// اتجاهات الانزلاق
enum SlideDirection {
  right,
  left,
  up,
  down,
}

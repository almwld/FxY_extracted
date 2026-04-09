import 'package:flutter/material.dart';
import 'app_routes.dart';

// Screens imports - سيتم إنشاؤها لاحقاً
import '../../screens/splash/splash_screen.dart';
import '../../screens/splash/mode_switch_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/otp_verification_screen.dart';
import '../../screens/auth/biometric_screen.dart';
import '../../screens/auth/identity_info_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/main_navigation.dart';
import '../../screens/home/search_screen.dart';
import '../../screens/product/products_screen.dart';
import '../../screens/product/product_detail_screen.dart';
import '../../screens/product/product_categories_screen.dart';
import '../../screens/product/category_products_screen.dart';
import '../../screens/categories/all_categories_screen.dart';
import '../../screens/ad/add_ad_screen.dart';
import '../../screens/ad/ad_detail_screen.dart';
import '../../screens/ad/my_ads_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/cart/checkout_screen.dart';
import '../../screens/order/orders_screen.dart';
import '../../screens/order/order_detail_screen.dart';
import '../../screens/order/order_tracking_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/wallet/wallet_screen.dart';
import '../../screens/wallet/deposit_screen.dart';
import '../../screens/wallet/withdraw_screen.dart';
import '../../screens/wallet/transfer_screen.dart';
import '../../screens/wallet/transactions_screen.dart';
import '../../screens/wallet/bill_payment_screen.dart';
import '../../screens/wallet/recharge_screen.dart';
import '../../screens/wallet/gift_cards_screen.dart';
import '../../screens/wallet/currency_exchange_screen.dart';
import '../../screens/wallet/qr_code_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/chat/chat_detail_screen.dart';
import '../../screens/map/interactive_map_screen.dart';
import '../../screens/map/nearby_stores_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/addresses_screen.dart';
import '../../screens/profile/payment_methods_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/language_screen.dart';
import '../../screens/settings/theme_screen.dart';
import '../../screens/settings/notifications_settings_screen.dart';
import '../../screens/settings/privacy_policy_screen.dart';
import '../../screens/settings/terms_screen.dart';
import '../../screens/settings/about_screen.dart';
import '../../screens/seller/seller_dashboard.dart';
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/support/help_support_screen.dart';
import '../../screens/support/faq_screen.dart';
import '../../screens/notifications/notifications_screen.dart';

/// مولد المسارات
class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Splash & Onboarding
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.modeSwitch:
        return MaterialPageRoute(builder: (_) => const ModeSwitchScreen());

      // Auth
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
      case AppRoutes.biometric:
        return MaterialPageRoute(builder: (_) => const BiometricScreen());
      case AppRoutes.identityInfo:
        return MaterialPageRoute(builder: (_) => const IdentityInfoScreen());

      // Home
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.mainNavigation:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      // Products
      case AppRoutes.products:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case AppRoutes.productDetail:
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: args as String),
        );
      case AppRoutes.productCategories:
        return MaterialPageRoute(builder: (_) => const ProductCategoriesScreen());
      case AppRoutes.categoryProducts:
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(categoryId: args as String),
        );

      // Categories
      case AppRoutes.allCategories:
        return MaterialPageRoute(builder: (_) => const AllCategoriesScreen());

      // Ads
      case AppRoutes.addAd:
        return MaterialPageRoute(builder: (_) => const AddAdScreen());
      case AppRoutes.adDetail:
        return MaterialPageRoute(
          builder: (_) => AdDetailScreen(adId: args as String),
        );
      case AppRoutes.myAds:
        return MaterialPageRoute(builder: (_) => const MyAdsScreen());

      // Cart
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      // Orders
      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case AppRoutes.orderDetail:
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: args as String),
        );
      case AppRoutes.orderTracking:
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: args as String),
        );
      case AppRoutes.myOrders:
        return MaterialPageRoute(builder: (_) => const MyOrdersScreen());

      // Favorites
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      // Wallet
      case AppRoutes.wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case AppRoutes.deposit:
        return MaterialPageRoute(builder: (_) => const DepositScreen());
      case AppRoutes.withdraw:
        return MaterialPageRoute(builder: (_) => const WithdrawScreen());
      case AppRoutes.transfer:
        return MaterialPageRoute(builder: (_) => const TransferScreen());
      case AppRoutes.transactions:
        return MaterialPageRoute(builder: (_) => const TransactionsScreen());
      case AppRoutes.billPayment:
        return MaterialPageRoute(builder: (_) => const BillPaymentScreen());
      case AppRoutes.recharge:
        return MaterialPageRoute(builder: (_) => const RechargeScreen());
      case AppRoutes.giftCards:
        return MaterialPageRoute(builder: (_) => const GiftCardsScreen());
      case AppRoutes.currencyExchange:
        return MaterialPageRoute(builder: (_) => const CurrencyExchangeScreen());
      case AppRoutes.qrCode:
        return MaterialPageRoute(builder: (_) => const QrCodeScreen());

      // Chat
      case AppRoutes.chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case AppRoutes.chatDetail:
        return MaterialPageRoute(
          builder: (_) => ChatDetailScreen(conversationId: args as String),
        );

      // Map
      case AppRoutes.interactiveMap:
        return MaterialPageRoute(builder: (_) => const InteractiveMapScreen());
      case AppRoutes.nearbyStores:
        return MaterialPageRoute(builder: (_) => const NearbyStoresScreen());

      // Profile
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.addresses:
        return MaterialPageRoute(builder: (_) => const AddressesScreen());
      case AppRoutes.paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentMethodsScreen());

      // Settings
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case AppRoutes.theme:
        return MaterialPageRoute(builder: (_) => const ThemeScreen());
      case AppRoutes.notificationsSettings:
        return MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case AppRoutes.terms:
        return MaterialPageRoute(builder: (_) => const TermsScreen());
      case AppRoutes.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      // Seller
      case AppRoutes.sellerDashboard:
        return MaterialPageRoute(builder: (_) => const SellerDashboard());

      // Admin
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      // Support
      case AppRoutes.helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case AppRoutes.faq:
        return MaterialPageRoute(builder: (_) => const FaqScreen());

      // Notifications
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('خطأ'),
        ),
        body: const Center(
          child: Text('الصفحة غير موجودة'),
        ),
      ),
    );
  }
}

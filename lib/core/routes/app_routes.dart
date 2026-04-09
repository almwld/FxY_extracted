/// مسارات التطبيق
class AppRoutes {
  AppRoutes._();

  // Splash & Onboarding
  static const String splash = '/';
  static const String modeSwitch = '/mode-switch';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String biometric = '/biometric';
  static const String identityInfo = '/identity-info';

  // Home
  static const String home = '/home';
  static const String homePro = '/home-pro';
  static const String mainNavigation = '/main-navigation';
  static const String search = '/search';

  // Products
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String productReviews = '/product-reviews';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String productCategories = '/product-categories';
  static const String categoryProducts = '/category-products';
  static const String allAds = '/all-ads';

  // Categories
  static const String allCategories = '/all-categories';
  static const String categories = '/categories';

  // Ads
  static const String addAd = '/add-ad';
  static const String adDetail = '/ad-detail';
  static const String myAds = '/my-ads';
  static const String reportAd = '/report-ad';

  // Cart
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Orders
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';
  static const String orderSuccess = '/order-success';
  static const String myOrders = '/my-orders';
  static const String trackOrder = '/track-order';

  // Favorites
  static const String favorites = '/favorites';

  // Wallet
  static const String wallet = '/wallet';
  static const String deposit = '/deposit';
  static const String withdraw = '/withdraw';
  static const String transfer = '/transfer';
  static const String transactions = '/transactions';
  static const String transfersHistory = '/transfers-history';
  static const String billPayment = '/bill-payment';
  static const String recharge = '/recharge';
  static const String banks = '/banks';
  static const String giftCards = '/gift-cards';
  static const String currencyExchange = '/currency-exchange';
  static const String cashWallet = '/cash-wallet';
  static const String youWallet = '/you-wallet';
  static const String ypayWallet = '/ypay-wallet';
  static const String mycashWallet = '/mycash-wallet';
  static const String telYWallet = '/tel-y-wallet';
  static const String flexPayWallet = '/flex-pay-wallet';
  static const String yemenMobileWallet = '/yemen-mobile-wallet';
  static const String sabafonWallet = '/sabafon-wallet';
  static const String addCard = '/add-card';
  static const String addBankAccount = '/add-bank-account';
  static const String qrCode = '/qr-code';

  // Chat
  static const String chat = '/chat';
  static const String chatDetail = '/chat-detail';

  // Map
  static const String interactiveMap = '/interactive-map';
  static const String professionalMap = '/professional-map';
  static const String osmMap = '/osm-map';
  static const String nearbyStores = '/nearby-stores';
  static const String enhancedMap = '/enhanced-map';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String addresses = '/addresses';
  static const String paymentMethods = '/payment-methods';
  static const String savedPaymentMethods = '/saved-payment-methods';
  static const String shareProfile = '/share-profile';
  static const String inviteFriends = '/invite-friends';
  static const String exportData = '/export-data';
  static const String connectedDevices = '/connected-devices';
  static const String loginHistory = '/login-history';
  static const String deleteAccount = '/delete-account';

  // Settings
  static const String settings = '/settings';
  static const String language = '/language';
  static const String theme = '/theme';
  static const String notificationsSettings = '/notifications-settings';
  static const String securitySettings = '/security-settings';
  static const String privacySettings = '/privacy-settings';
  static const String privacyBlock = '/privacy-block';
  static const String privacyPolicy = '/privacy-policy';
  static const String terms = '/terms';
  static const String about = '/about';
  static const String accountSettings = '/account-settings';

  // Seller
  static const String sellerDashboard = '/seller-dashboard';
  static const String sellerProducts = '/seller-products';
  static const String sellerOrders = '/seller-orders';
  static const String sellerAnalytics = '/seller-analytics';
  static const String sellerPayouts = '/seller-payouts';
  static const String sellerReviews = '/seller-reviews';
  static const String sellerCoupons = '/seller-coupons';

  // Admin
  static const String adminDashboard = '/admin-dashboard';
  static const String adminUsers = '/admin-users';
  static const String adminProducts = '/admin-products';
  static const String adminAds = '/admin-ads';
  static const String adminOrders = '/admin-orders';
  static const String adminCategories = '/admin-categories';
  static const String adminReports = '/admin-reports';
  static const String adminSellers = '/admin-sellers';
  static const String adminLogs = '/admin-logs';

  // Support
  static const String supportTickets = '/support-tickets';
  static const String liveSupport = '/live-support';
  static const String smartSupport = '/smart-support';
  static const String aiChatAssistant = '/ai-chat-assistant';
  static const String faq = '/faq';
  static const String helpSupport = '/help-support';
  static const String reportProblem = '/report-problem';

  // Garden
  static const String garden = '/garden';

  // Auctions
  static const String auctions = '/auctions';
  static const String auctionDetail = '/auction-detail';

  // Notifications
  static const String notifications = '/notifications';
}

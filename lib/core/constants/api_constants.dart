/// ثوابت API والاتصال بالخادم
class ApiConstants {
  ApiConstants._();

  // Supabase
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // OpenStreetMap
  static const String openStreetMapApiKey = String.fromEnvironment('OPENSTREETMAP_API_KEY');
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String tileServerUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // مهلات الطلبات
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // إعادة المحاولة
  static const int maxRetries = 3;
  static const int retryDelay = 1000;

  // التخزين المؤقت
  static const int cacheMaxAge = 7 * 24 * 60 * 60 * 1000; // 7 أيام
  static const int cacheMaxSize = 100 * 1024 * 1024; // 100 MB

  // الصفحات
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // المسافات
  static const double defaultSearchRadius = 10.0; // كيلومتر
  static const double maxSearchRadius = 100.0; // كيلومتر
}

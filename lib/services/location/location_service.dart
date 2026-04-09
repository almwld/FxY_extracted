import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// خدمة الموقع
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;

  /// الحصول على الموقع الحالي
  Position? get currentPosition => _currentPosition;

  /// التحقق من صلاحيات الموقع
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// الحصول على الموقع الحالي
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return _currentPosition;
    } catch (e) {
      return null;
    }
  }

  /// الحصول على آخر موقع معروف
  Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  /// الاستماع لتغييرات الموقع
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// حساب المسافة بين نقطتين
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// حساب المسافة من الموقع الحالي
  Future<double?> calculateDistanceFromCurrent(
    double latitude,
    double longitude,
  ) async {
    final position = await getCurrentLocation();
    if (position == null) return null;

    return calculateDistance(
      position.latitude,
      position.longitude,
      latitude,
      longitude,
    );
  }

  /// التحقق مما إذا كانت النقطة ضمن نطاق معين
  bool isWithinRadius(
    double centerLatitude,
    double centerLongitude,
    double pointLatitude,
    double pointLongitude,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(
      centerLatitude,
      centerLongitude,
      pointLatitude,
      pointLongitude,
    );
    return distance <= radiusInMeters;
  }

  /// الحصول على عنوان من الإحداثيات
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // يمكن استخدام خدمة geocoding هنا
      // للتبسيط، نعيد الإحداثيات كعنوان
      return '$latitude, $longitude';
    } catch (e) {
      return null;
    }
  }

  /// فتح الموقع في خرائط Google
  Future<void> openInGoogleMaps(
    double latitude,
    double longitude, {
    String? label,
  }) async {
    // استخدام url_launcher لفتح الخرائط
    // final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // await launchUrl(Uri.parse(url));
  }

  /// الحصول على اتجاه البوصلة
  Future<double?> getHeading() async {
    final position = await getCurrentLocation();
    return position?.heading;
  }

  /// التحقق مما إذا كان الموقع متاحاً
  Future<bool> isLocationAvailable() async {
    final position = await getCurrentLocation();
    return position != null;
  }

  /// تحويل الإحداثيات إلى LatLng
  LatLng toLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  /// تحويل Position إلى LatLng
  LatLng? get currentLatLng {
    if (_currentPosition == null) return null;
    return toLatLng(_currentPosition!);
  }
}

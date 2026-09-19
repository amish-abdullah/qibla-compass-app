import 'dart:math';

class QiblaHelper {
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  static double calculateQiblaDirection(double userLat, double userLng) {
    double lat1 = _toRadians(userLat);
    double lng1 = _toRadians(userLng);
    double lat2 = _toRadians(kaabaLat);
    double lng2 = _toRadians(kaabaLng);

    double deltaLng = lng2 - lng1;

    double y = sin(deltaLng) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLng);

    double bearing = atan2(y, x);
    bearing = _toDegrees(bearing);
    return (bearing + 360) % 360;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;
  static double _toDegrees(double radians) => radians * 180 / pi;
}
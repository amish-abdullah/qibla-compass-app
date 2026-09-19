import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesHelper {
  static Future<Map<String, String>> getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final timings = data['data']['timings'];

      return {
        'Fajr': timings['Fajr'],
        'Dhuhr': timings['Dhuhr'],
        'Asr': timings['Asr'],
        'Maghrib': timings['Maghrib'],
        'Isha': timings['Isha'],
      };
    } else {
      throw Exception('error fetching prayer times');
    }
  }
}
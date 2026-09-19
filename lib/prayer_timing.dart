import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'prayer_time_helper.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  Map<String, String>? prayerTimes;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final times = await PrayerTimesHelper.getPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() => prayerTimes = times);
    } catch (e) {
      setState(() => errorMessage = 'prayer time error, check your internet connection or location permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Prayer Timings", style: TextStyle(color: Colors.white)),
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : prayerTimes == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: prayerTimes!.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.access_time, color: Colors.blue),
                        title: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
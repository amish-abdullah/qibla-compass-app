import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'prayer_timing.dart';
import 'qibla_helper.dart';

class QiblaHomepage extends StatefulWidget {
  const QiblaHomepage({super.key});

  @override
  State<QiblaHomepage> createState() => _QiblaHomepageState();
}

class _QiblaHomepageState extends State<QiblaHomepage>
    with SingleTickerProviderStateMixin {
  double? qiblaDirection;
  double? currentHeading;
  StreamSubscription<CompassEvent>? compassSubscription;

  Animation<double>? animation;
  AnimationController? _animationController;
  double begin = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    _setupQibla();
  }

  Future<void> _setupQibla() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double qibla = QiblaHelper.calculateQiblaDirection(
      position.latitude,
      position.longitude,
    );

    setState(() => qiblaDirection = qibla);

    compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading == null || qiblaDirection == null) return;

      double target = ((qiblaDirection! - event.heading!) * pi / 180) * -1;

      setState(() {
        currentHeading = event.heading;
        animation = Tween(begin: begin, end: target).animate(_animationController!);
        begin = target;
        _animationController!.forward(from: 0);
      });
    });
  }

  // Qibla aur current heading ke beech ka difference (0-360 range mein normalize)
  double get _degreeDifference {
    if (qiblaDirection == null || currentHeading == null) return 0;
    double diff = (qiblaDirection! - currentHeading!) % 360;
    if (diff < 0) diff += 360;
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  bool get _isAligned => _degreeDifference <= 3; 

  @override
  void dispose() {
    compassSubscription?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text("Qiblah Direction",style: TextStyle(
          color: Colors.white,
        ),)),
      ),
      body: qiblaDirection == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "${_degreeDifference.toStringAsFixed(0)}°",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isAligned ? Colors.green : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: animation!,
                    builder: (context, child) => Transform.rotate(
                      angle: animation!.value,
                      child: Image.asset("assets/images/Qiblah.jpg"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                ],
              ),
          ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qiblahcompuss_app/main_page.dart';
import 'package:qiblahcompuss_app/qibla_homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool haspermission = false;
  late Future<void> _permissionFuture;

  @override
  void initState() {
    super.initState();
    _permissionFuture = getpermission(); 
  }

  Future<void> getpermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      setState(() => haspermission = true);
    } else {
      var result = await Permission.location.request();
      setState(() => haspermission = (result == PermissionStatus.granted));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _permissionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (haspermission) {
            return const MainScreen(
              
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.blue,
              body: Center(
                child: Text(
                  "Location permission chahiye",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
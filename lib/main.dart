import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/dependency_injection.dart';
import 'package:telugu_matka/Controller/network_controller.dart';
import 'package:telugu_matka/Splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ConnectivityResult initialConnectivity =
      await Connectivity().checkConnectivity();

  runApp(MyApp(initialConnectivity: initialConnectivity));
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final ConnectivityResult initialConnectivity;
  const MyApp({super.key, required this.initialConnectivity});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (initialConnectivity == ConnectivityResult.none) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoInternetScreen(),
      );
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telugu Matka',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

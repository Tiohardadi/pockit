import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pockit/persentation/screens/login.dart';
import 'package:pockit/persentation/screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFF4285F4),
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pockit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4285F4),
        scaffoldBackgroundColor: const Color(0xFF4285F4),
      ),
      home: const SplashScreenWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

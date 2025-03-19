import 'package:flutter/material.dart';
import 'package:pockit/presentation/screens/login.dart';
import 'package:pockit/presentation/screens/register.dart';
import 'package:pockit/presentation/screens/home.dart';
import 'package:pockit/presentation/screens/splash.dart';
import 'package:pockit/utils/shared_prefs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await SharedPrefs.isUserLoggedIn();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pockit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoading
          ? const Center(child: CircularProgressIndicator())
          :  const SplashScreenWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pockit/persentation/components/main_layout.dart';
import 'package:pockit/persentation/screens/login.dart';
import 'package:pockit/persentation/screens/register.dart';
import 'package:pockit/persentation/screens/transaksi.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Transaksi(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pockit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainLayout(
        child: _pages[_currentIndex],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

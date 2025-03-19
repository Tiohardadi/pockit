import 'package:flutter/material.dart';
import 'package:pockit/presentation/components/main_layout.dart';
import 'package:pockit/presentation/screens/transaksi.dart';
import 'package:pockit/presentation/screens/splitbill.dart';
import 'package:pockit/presentation/screens/pocket.dart';
import 'package:pockit/presentation/screens/profile.dart';
import 'package:pockit/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Transaksi(),
      const Splitbill(),
      const Pocket(),
      const Profile(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
    );
  }
}

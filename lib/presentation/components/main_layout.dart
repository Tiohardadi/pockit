import 'package:flutter/material.dart';
import 'package:pockit/presentation/constant/app_colors.dart';
import 'package:pockit/presentation/constant/utils.dart';
import 'package:pockit/presentation/screens/tambah_transaksi.dart';
import 'navbar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTap;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: child,
    bottomNavigationBar: Navbar(
      currentIndex: currentIndex,
      onTap: onTap,
    ),
    floatingActionButton: Container(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: () {
          Utils.pushWithFade(context, TambahTransaksi());
          print("object");
        },
        backgroundColor: Colors.transparent, // Make background transparent
        shape: const CircleBorder(),
        elevation: 0,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}
}

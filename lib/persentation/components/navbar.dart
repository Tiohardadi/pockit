import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:pockit/persentation/constant/app_colors.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Navbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  final List<IconData> iconList = [
    Icons.money,
    Icons.receipt_long,
    Icons.account_balance_wallet,
    Icons.pie_chart,
  ];

  final List<String> labels = ["Transaksi", "Split Bill", "Pocket", "Report"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -5, // Mengatur posisi bayangan agar pas
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2), // Warna bayangan
                  blurRadius: 20, // Efek blur bayangan
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
        AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 7),
                Icon(
                  iconList[index],
                  color: isActive ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(height: 4), // Jarak antara icon dan teks
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            );
          },
          activeIndex: currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          backgroundColor: Colors.white,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          // inactiveColor: Colors.grey,
          // activeColor: AppColors.primary,
          onTap: onTap,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:pockit/presentation/constant/app_colors.dart';
import 'package:pockit/presentation/screens/splitbill.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Navbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  final List<IconData> iconList = [
    Icons.attach_money,
    Icons.receipt_long,
    Icons.account_balance_wallet,
    Icons.person,
  ];

  final List<String> labels = ["Transaksi", "Split Bill", "Pocket", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -5,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
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
                const SizedBox(height: 4),
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
          activeIndex:
              currentIndex < iconList.length
                  ? currentIndex
                  : 0, // Prevent index out of bounds
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          backgroundColor: Colors.white,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          onTap: (index) {
            // First check if the index is valid to avoid errors
            if (index >= 0 && index < iconList.length) {
              // Call the parent's onTap callback yang akan memunculkan halaman yang sesuai
              onTap(index);

              // Tidak perlu navigasi manual, karena halaman akan ditampilkan melalui MainLayout
              // Hapus kode navigasi ini:
              // if (index == 1) {
              //   try {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => Splitbill()),
              //     );
              //   } catch (e) {
              //     // Handle navigation error
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text("Tidak dapat membuka Split Bill: ${e.toString()}")),
              //     );
              //   }
              // }
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pockit/persentation/constant/app_colors.dart';
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
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 0,
                child: Container(), // Dikosongkan agar ikon plus dibuat terpisah
              ),
            ),
          ),
          const Icon(Icons.add, size: 32, color: Colors.white), // Ikon plus di atas FAB
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

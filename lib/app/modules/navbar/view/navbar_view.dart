import 'package:flutter/material.dart';

import '../../../widgets/build_header_app.dart';
import '../../adopsi/view/adopsi_view.dart';
import '../../home/view/home_view.dart';
import '../../pesanan/view/pesanan_view.dart';
import '../../profil/view/profil_view.dart';
import '../widgets/bottom_navbar.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int selectedIndex = 0;

  final List<Widget> pages = const [HomeView(), AdopsiView(), PesananView(), ProfilView()];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onFavoriteTap() {
    // TODO: arahkan ke halaman favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (selectedIndex != 3)
              BuildAppHeader(onFavoriteTap: onFavoriteTap),
            Expanded(
              child: IndexedStack(index: selectedIndex, children: pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavbar(currentIndex: selectedIndex, onTap: onItemTapped),
    );
  }
}

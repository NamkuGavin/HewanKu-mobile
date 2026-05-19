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

  void onItemTapped(int index) {
    setState(() => selectedIndex = index);
  }

  void onFavoriteTap() {
    // TODO: arahkan ke halaman favorit
  }

  // Dipanggil dari HomeView saat user tekan "Adopsi Sekarang"
  void goToAdopsi() {
    setState(() => selectedIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeView(onGoToAdopsi: goToAdopsi),
      const AdopsiView(),
      const PesananView(),
      const ProfilView(),
    ];

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
      bottomNavigationBar: AppBottomNavbar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}

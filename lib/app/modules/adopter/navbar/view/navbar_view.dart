import 'package:flutter/material.dart';

import '../../../../widgets/build_header_app.dart';
import '../../adopsi/view/adopsi_navigation_controller.dart';
import '../../adopsi/view/adopsi_view.dart';
import '../../home/view/home_view.dart';
import '../../pesanan/view/pesanan_view.dart';
import '../../profil/view/profil_view.dart';
import '../view/navbar_controller.dart';
import '../widgets/bottom_navbar.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    NavbarController.tabIndex.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    NavbarController.tabIndex.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() => selectedIndex = NavbarController.tabIndex.value);
  }

  void onItemTapped(int index) {
    NavbarController.tabIndex.value = index;
  }

  void goToAdopsi() {
    NavbarController.goTo(1);
  }

  void goToAdopsiWithCategory(String category) {
    AdopsiNavigationController.filterByCategory(category);
    NavbarController.goTo(1);
  }

  void goToAdopsiSearch() {
    AdopsiNavigationController.openSearch();
    NavbarController.goTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeView(
        onGoToAdopsi: goToAdopsi,
        onGoToAdopsiCategory: goToAdopsiWithCategory,
        onGoToAdopsiSearch: goToAdopsiSearch,
      ),
      const AdopsiView(),
      const PesananView(),
      const ProfilView(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (selectedIndex != 3) BuildAppHeader(onFavoriteTap: () {}),
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

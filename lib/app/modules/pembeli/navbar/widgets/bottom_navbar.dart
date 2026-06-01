import 'package:flutter/material.dart';

import '../../../../common/contant/assets.dart';

class AppBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      fixedColor: Theme.of(context).primaryColor,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: textTheme.labelLarge,
      unselectedLabelStyle: textTheme.labelLarge,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(IconAsset.home),
          activeIcon: Image.asset(IconAsset.homeActive),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(IconAsset.paw),
          activeIcon: Image.asset(IconAsset.pawActive),
          label: 'Adopsi',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(IconAsset.cart),
          activeIcon: Image.asset(IconAsset.cartActive),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(IconAsset.profile),
          activeIcon: Image.asset(IconAsset.profileActive),
          label: 'Profil',
        ),
      ],
    );
  }
}

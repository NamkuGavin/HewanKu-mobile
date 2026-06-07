import 'package:flutter/material.dart';

import '../../home/view/home_view.dart';
import '../../hewan/view/hewan_view.dart';
import '../../profil/view/profil_shelter_view.dart';
import '../../permohonan/view/permohonan_view.dart';

// ============================================================
// lib/app/modules/shelter/navbar/view/navbar_view.dart
//
// FIX: tambah _goToHewan() dan _goToPermohonan()
//      lalu pass ke HomeShelterView
// ============================================================

class NavbarShelterView extends StatefulWidget {
  const NavbarShelterView({super.key});

  @override
  State<NavbarShelterView> createState() => _NavbarShelterViewState();
}

class _NavbarShelterViewState extends State<NavbarShelterView> {
  int _selectedIndex = 0;

  void _goToProfil() => setState(() => _selectedIndex = 3);
  void _goToHewan() => setState(() => _selectedIndex = 1); // ← BARU
  void _goToPermohonan() => setState(() => _selectedIndex = 2); // ← BARU

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeShelterView(
        onGoToProfil: _goToProfil,
        onGoToHewan: _goToHewan, // ← BARU
        onGoToPermohonan: _goToPermohonan, // ← BARU
      ),
      const HewanShelterView(),
      const PermohonanView(),
      const ProfilShelterView(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF87537),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Hewan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Permohonan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

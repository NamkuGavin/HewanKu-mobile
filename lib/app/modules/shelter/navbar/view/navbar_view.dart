import 'package:flutter/material.dart';

// Import halaman-halaman milik shelter
import '../../home/view/home_view.dart';
// Catatan: Pastikan view di bawah ini sudah kamu buat file kosongnya agar tidak error
// import '../../hewan/view/hewan_view.dart';
// import '../../permohonan/view/permohonan_view.dart';
// import '../../profil/view/profil_view.dart';

class NavbarShelterView extends StatefulWidget {
  const NavbarShelterView({super.key});

  @override
  State<NavbarShelterView> createState() => _NavbarShelterViewState();
}

class _NavbarShelterViewState extends State<NavbarShelterView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
    final List<Widget> pages = [
      const HomeShelterView(),
      const Scaffold(
        body: Center(child: Text('Halaman Manajemen Hewan')),
      ), // Ganti dengan HewanView() jika sudah ada
      const Scaffold(
        body: Center(child: Text('Halaman Permohonan Adopsi')),
      ), // Ganti dengan PermohonanView()
      const Scaffold(
        body: Center(child: Text('Halaman Profil Shelter')),
      ), // Ganti dengan ProfilView()
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(
          0xFFF87537,
        ), // Warna oranye utama dari AppThemeData
        unselectedItemColor: Colors.grey,
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
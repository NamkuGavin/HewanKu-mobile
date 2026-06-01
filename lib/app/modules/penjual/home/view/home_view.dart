import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TAMBAHKAN KEDUA BARIS IMPORT INI:
import '../../navbar/widgets/hewan_card.dart';
import '../../navbar/widgets/permohonan_card.dart';

class HomePenjualView extends StatelessWidget {
  const HomePenjualView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 1. HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.pets, color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'HewanKu',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFFF87537),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. SEARCH BAR
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Cari Hewan...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFE9E9E9),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. BANNER PROMOSI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shelter Hewan',
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFF87537),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ayo Buat Shelter\nKamu',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kelola hewan peliharaan dan temukan pemilik baru untuk mereka.',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFF87537),
                        minimumSize: Size(double.infinity, 45.h),
                        side: const BorderSide(color: Color(0xFFE9E9E9)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.storefront),
                      label: const Text('Daftar Shelter'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF87537),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45.h),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Daftar Hewan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. STATISTIK
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SIAP ADOPSI',
                          style: textTheme.labelMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '24',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('Ekor', style: textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.bar_chart,
                      color: Color(0xFFF87537),
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. BAGIAN: HEWAN DI SHELTER KAMU
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hewan di Shelter kamu',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Color(0xFFF87537)),
                    ),
                  ),
                ],
              ),
              // MEMANGGIL WIDGET YANG SUDAH DIPISAHKAN
              const HewanCard(
                name: 'Mochi',
                price: 'Rp 0 (Adopsi)',
                status: 'AKTIF',
                statusColor: Colors.green,
              ),
              const HewanCard(
                name: 'Buddy',
                price: 'Rp 0 (Adopsi)',
                status: 'PENDING',
                statusColor: Colors.orange,
              ),
              const SizedBox(height: 20),

              // 6. BAGIAN: PERMOHONAN ADOPSI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permohonan Adopsi',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Color(0xFFF87537)),
                    ),
                  ),
                ],
              ),
              // MEMANGGIL WIDGET YANG SUDAH DIPISAHKAN
              const PermohonanCard(
                petName: 'Milo',
                requester: 'Requested by Sarah Jenkins',
              ),
              const PermohonanCard(
                petName: 'Bella',
                requester: 'Requested by David Chen',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

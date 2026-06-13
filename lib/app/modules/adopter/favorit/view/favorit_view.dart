import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/app_navigator.dart';
import '../../adopsi/view/adopsi_detail_hewan.dart';
import '../model/favorit_item.dart';
import '../model/favorit_provider.dart';
import '../widgets/favorit_item_card.dart';
import '../widgets/favorit_empty_state.dart';

class FavoritView extends StatefulWidget {
  const FavoritView({super.key});

  @override
  State<FavoritView> createState() => _FavoritViewState();
}

class _FavoritViewState extends State<FavoritView> {
  bool _isDeleteMode = false;
  final Set<String> _selectedNames = {};

  void _toggleDeleteMode(List<FavoritItem> favoritList) {
    if (_isDeleteMode && _selectedNames.isNotEmpty) {
      // Hapus semua yang dicentang
      for (final name in _selectedNames) {
        FavoritProvider.hapus(
          context,
          favoritList.firstWhere((f) => f.namaHewan == name),
        );
      }
    }
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      _selectedNames.clear();
    });
  }

  void _toggleSelect(String namaHewan) {
    setState(() {
      if (_selectedNames.contains(namaHewan)) {
        _selectedNames.remove(namaHewan);
      } else {
        _selectedNames.add(namaHewan);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ValueListenableBuilder<List<FavoritItem>>(
      valueListenable: FavoritProvider.of(context),
      builder: (context, favoritList, _) {
        // Balik urutan — terbaru di atas
        final sortedList = favoritList.reversed.toList();
        final isEmpty = sortedList.isEmpty;

        // Kalau list kosong, keluar dari delete mode otomatis
        if (isEmpty && _isDeleteMode) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isDeleteMode = false;
              _selectedNames.clear();
            });
          });
        }

        return Scaffold(
          backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
          appBar: AppBar(
            backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                if (_isDeleteMode) {
                  // Batalkan mode hapus
                  setState(() {
                    _isDeleteMode = false;
                    _selectedNames.clear();
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                _isDeleteMode
                    ? Icons.close_rounded
                    : Icons.arrow_back_ios_new_rounded,
                color: primaryColor,
                size: 20.sp,
              ),
            ),
            title: Text(
              _isDeleteMode
                  ? (_selectedNames.isEmpty
                        ? 'Pilih item'
                        : '${_selectedNames.length} dipilih')
                  : 'Favorit',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            actions: [
              if (!isEmpty)
                IconButton(
                  onPressed: () => _toggleDeleteMode(sortedList),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: _isDeleteMode && _selectedNames.isNotEmpty
                        ? Colors.red
                        : primaryColor,
                    size: 22.sp,
                  ),
                ),
            ],
          ),
          body: isEmpty
              ? const FavoritEmptyState()
              : ListView.separated(
                  itemCount: sortedList.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (context, index) {
                    final item = sortedList[index];
                    final isSelected = _selectedNames.contains(item.namaHewan);

                    return FavoritItemCard(
                      item: item,
                      isHighlighted: index == 0 && !_isDeleteMode,
                      isDeleteMode: _isDeleteMode,
                      isSelected: isSelected,
                      onTap: () {
                        if (_isDeleteMode) {
                          _toggleSelect(item.namaHewan);
                        } else {
                          AppNavigator.push(
                            context,
                            AdopsiDetailHewanView(hewan: item.hewan),
                          );
                        }
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

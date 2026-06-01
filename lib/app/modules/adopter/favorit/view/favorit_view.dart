import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/favorit_item.dart';
import '../model/favorit_provider.dart';
import '../widgets/favorit_item_card.dart';
import '../widgets/favorit_empty_state.dart';

class FavoritView extends StatelessWidget {
  const FavoritView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ValueListenableBuilder<List<FavoritItem>>(
      valueListenable: FavoritProvider.of(context),
      builder: (context, favoritList, _) {
        final isEmpty = favoritList.isEmpty;
        return Scaffold(
          backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
          appBar: AppBar(
            backgroundColor: isEmpty ? const Color(0xFFF5F5F5) : Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryColor,
                size: 20.sp,
              ),
            ),
            title: Text(
              'Favorit',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          body: isEmpty
              ? const FavoritEmptyState()
              : ListView.separated(
                  itemCount: favoritList.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (context, index) {
                    return FavoritItemCard(
                      item: favoritList[index],
                      isHighlighted: index == 0,
                      onTap: () {
                        // TODO: navigasi ke detail hewan
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
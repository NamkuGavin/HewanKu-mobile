import 'package:flutter/material.dart';

import '../../adopsi/widgets/hewan_model.dart';
import '../../adopsi/widgets/hewan_showcase_card.dart';

class HomeAnimalCard extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback? onTap;

  const HomeAnimalCard({super.key, required this.hewan, this.onTap});

  @override
  Widget build(BuildContext context) {
    return HewanShowcaseCard(hewan: hewan, onTap: onTap, imageHeight: 132);
  }
}

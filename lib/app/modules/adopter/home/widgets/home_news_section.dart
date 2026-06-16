import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/app_net_image.dart';
import '../../../../models/home/adopter_news_model.dart';
import 'home_news_list_item.dart';
import 'home_section_placeholder.dart';

class HomeNewsSection extends StatelessWidget {
  final List<AdopterNewsArticleModel> items;
  final bool hasError;
  final VoidCallback onRetry;

  const HomeNewsSection({
    super.key,
    required this.items,
    required this.hasError,
    required this.onRetry,
  });

  Future<void> _bukaArtikel(BuildContext context, String url) async {
    final normalizedUrl = url.trim();
    final uri = Uri.tryParse(normalizedUrl);

    if (uri == null ||
        normalizedUrl.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      AppSnackbar.show(
        context,
        message: 'Link berita tidak valid.',
        type: AppSnackbarType.warning,
      );
      return;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (launched) {
        return;
      }

      final launchedExternal = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launchedExternal) {
        return;
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }
    }

    if (context.mounted) {
      AppSnackbar.show(
        context,
        message: 'Berita tidak bisa dibuka saat ini.',
        type: AppSnackbarType.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final highlightItem = items.isNotEmpty ? items.first : null;
    final listItems = items.skip(1).take(5).toList(growable: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berita Terkini',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),
          if (hasError)
            HomeSectionPlaceholder(
              icon: Icons.article_outlined,
              title: 'Berita terkini belum bisa dimuat.',
              description:
                  'Coba muat ulang untuk mengambil berita terbaru dari server.',
              onRetry: onRetry,
            )
          else if (highlightItem == null)
            const SizedBox.shrink()
          else ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: GestureDetector(
                onTap: () => _bukaArtikel(context, highlightItem.link),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 190.h,
                      child: AppNetImage(
                        url: highlightItem.imageUrl,
                        fallbackColor: const Color(0xFFE0E0E0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            highlightItem.category,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            highlightItem.title,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            highlightItem.formattedDate,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Divider(color: primaryColor, thickness: 1.5),
                          SizedBox(height: 8.h),
                          Text(
                            highlightItem.description,
                            style: textTheme.labelLarge?.copyWith(
                              color: const Color(0xFF757575),
                              height: 1.6,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listItems.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = listItems[index];
                return HomeNewsListItem(
                  imageUrl: item.imageUrl,
                  kategori: item.category,
                  judul: item.title,
                  tanggal: item.formattedDate,
                  onTap: () => _bukaArtikel(context, item.link),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

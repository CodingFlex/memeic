import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';

import 'meme_detail_viewmodel.dart';

class MemeDetailView extends StackedView<MemeDetailViewModel> {
  final MemeModel meme;
  final Set<String>? favoriteIds;
  final String? heroTag;

  const MemeDetailView({
    Key? key,
    required this.meme,
    this.favoriteIds,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MemeDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcAppBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back and Favorite
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: viewModel.onBackPressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: kcVeryDarkBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: viewModel.toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: kcVeryDarkBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        viewModel.isFavorite
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: viewModel.isFavorite ? Colors.red : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceMedium,
                    // Meme Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag: heroTag ?? 'meme_image_${meme.id}',
                        child: CachedNetworkImage(
                          imageUrl: viewModel.meme.imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            height: 300,
                            color: kcDarkGreyColor,
                            child: Skeletonizer(
                              enabled: true,
                              child: Container(
                                height: 300,
                                color: kcMediumGrey,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 300,
                            color: kcDarkGreyColor,
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.image,
                                color: kcMediumGrey,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                    // Caption
                    if (viewModel.meme.title != null)
                      Text(
                        viewModel.meme.title!,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.heading3(
                          context,
                          color: Colors.white,
                        ),
                      ),
                    verticalSpaceMedium,
                    // Tags
                    if (viewModel.meme.tags != null &&
                        viewModel.meme.tags!.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.start,
                        children: viewModel.meme.tags!.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: kcPrimaryColor.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: kcPrimaryColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.caption(context,
                                  color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    verticalSpaceMedium,
                    // Action Buttons (2x2 Grid)
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: FontAwesomeIcons.shareNodes,
                            label: 'Share',
                            onTap: viewModel.onShare,
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: _ActionButton(
                            icon: FontAwesomeIcons.download,
                            label: 'Download',
                            onTap: viewModel.onDownload,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    verticalSpaceTiny,
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: FontAwesomeIcons.heart,
                            label: 'Save',
                            onTap: viewModel.onSave,
                          ),
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                          child: _ActionButton(
                            icon: FontAwesomeIcons.copy,
                            label: 'Copy',
                            onTap: viewModel.onCopy,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceLarge,
                    // Similar Memes Section
                    horizontalSpaceSmall,
                    Text(
                      'Similar Memes',
                      style:
                          AppTextStyles.heading3(context, color: Colors.white),
                    ),
                    verticalSpaceMedium,
                    // Similar Memes List
                    if (viewModel.isLoadingSimilar)
                      Skeletonizer(
                        enabled: true,
                        child: SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (context, index) =>
                                horizontalSpaceSmall,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kcMediumGrey,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: kcMediumGrey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.similarMemes.length,
                          separatorBuilder: (context, index) =>
                              horizontalSpaceSmall,
                          itemBuilder: (context, index) {
                            final similarMeme = viewModel.similarMemes[index];
                            return SizedBox(
                              width: 150,
                              child: GestureDetector(
                                onTap: () =>
                                    viewModel.onSimilarMemePressed(similarMeme),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: similarMeme.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: kcDarkGreyColor,
                                            child: Skeletonizer(
                                              enabled: true,
                                              child: Container(
                                                color: kcMediumGrey,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: kcDarkGreyColor,
                                            child: const Center(
                                              child: FaIcon(
                                                FontAwesomeIcons.image,
                                                color: kcMediumGrey,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    if (similarMeme.title != null)
                                      Text(
                                        similarMeme.title!,
                                        style: AppTextStyles.caption(context,
                                                color: Colors.white)
                                            .copyWith(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    verticalSpaceLarge,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  MemeDetailViewModel viewModelBuilder(BuildContext context) {
    return MemeDetailViewModel(
      meme: meme,
      favoriteIds: favoriteIds,
    )..loadSimilarMemes();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(166, 34, 39, 51),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(186, 90, 41, 124),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            horizontalSpaceSmall,
            Text(
              label,
              style: AppTextStyles.body(context, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/common/meme_card.dart';
import 'package:memeic/ui/views/search/widgets/search_bar_widget.dart';
import 'package:memeic/ui/views/search/widgets/trending_mood_item.dart';
import 'package:memeic/ui/views/search/widgets/popular_mood_chip.dart';
import 'package:memeic/ui/views/search/widgets/search_empty_state.dart';

import 'search_viewmodel.dart';

class SearchView extends StackedView<SearchViewModel> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcAppBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpaceSmall,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: viewModel.onBackPressed,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: kcDarkGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: SearchBarWidget(
                      controller: viewModel.searchController,
                      onChanged: viewModel.onSearchChanged,
                      onVoiceSearch: viewModel.onVoiceSearch,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.showTrending && !viewModel.isLoading) ...[
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.arrowTrendUp,
                            color: kcPrimaryColorLight,
                            size: 16,
                          ),
                          horizontalSpaceTiny,
                          Text(
                            'Trending Now',
                            style: AppTextStyles.heading3(context,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      ...viewModel.trendingMoods.map((mood) {
                        return TrendingMoodItem(
                          emoji: mood.emoji,
                          label: mood.label,
                          percentage: mood.percentage ?? 0,
                          onTap: () => viewModel.onMoodSelected(mood),
                        );
                      }),
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular moods',
                            style: AppTextStyles.heading3(context,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: viewModel.onPreviewTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: kcMediumGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Preview',
                                style: AppTextStyles.caption(context,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      if (viewModel.isLoadingTags ||
                          viewModel.isLoadingCategories)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(9, (index) {
                            return Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                color: kcDarkGreyColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        )
                      else if (viewModel.popularMoods.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No tags available',
                            style: AppTextStyles.body(
                              context,
                              color: kcMediumGrey,
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: viewModel.popularMoods.map((mood) {
                            return PopularMoodChip(
                              label: mood.label,
                              emoji: mood.emoji,
                              count: mood.percentage,
                              onTap: () => viewModel.onMoodSelected(mood),
                            );
                          }).toList(),
                        ),
                      verticalSpaceLarge,
                    ],
                    if (viewModel.isLoading)
                      Skeletonizer(
                        enabled: true,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: kcMediumGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      )
                    else if (!viewModel.showTrending)
                      viewModel.memes.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 120,
                              ),
                              child: SearchEmptyState(
                                onPreviewTap: viewModel.onPreviewTap,
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: viewModel.memes.length,
                              itemBuilder: (context, index) {
                                final meme = viewModel.memes[index];
                                return MemeCard(
                                  imageUrl: meme.imageUrl,
                                  onTap: () => viewModel.onMemePressed(meme),
                                  onFavorite: () =>
                                      viewModel.toggleFavorite(meme),
                                  isFavorite: viewModel.isFavorite(meme.id),
                                );
                              },
                            ),
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
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();
}

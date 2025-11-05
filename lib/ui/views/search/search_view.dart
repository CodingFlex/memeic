import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/common/meme_card.dart';
import 'package:memeic/ui/views/search/widgets/search_bar_widget.dart';
import 'package:memeic/ui/views/search/widgets/mood_chip.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    controller: viewModel.searchController,
                    onChanged: viewModel.onSearchChanged,
                    onVoiceSearch: viewModel.onVoiceSearch,
                  ),
                  verticalSpaceSmall,
                  if (viewModel.showTrending) ...[
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.arrowTrendUp,
                          color: kcPrimaryColor,
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
                    verticalSpaceTiny,
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.trendingMoods.length,
                        separatorBuilder: (context, index) =>
                            horizontalSpaceTiny,
                        itemBuilder: (context, index) {
                          final mood = viewModel.trendingMoods[index];
                          return MoodChip(
                            emoji: mood.emoji,
                            label: mood.label,
                            percentage: mood.percentage,
                            onTap: () => viewModel.onMoodSelected(mood),
                          );
                        },
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                  if (!viewModel.showTrending) ...[
                    Text(
                      'Popular moods',
                      style:
                          AppTextStyles.heading3(context, color: Colors.white),
                    ),
                    verticalSpaceTiny,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: viewModel.popularMoods.map((mood) {
                        return MoodChip(
                          emoji: mood.emoji,
                          label: mood.label,
                          onTap: () => viewModel.onMoodSelected(mood),
                        );
                      }).toList(),
                    ),
                    verticalSpaceMedium,
                  ],
                ],
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? Skeletonizer(
                      enabled: true,
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              getResponsiveHorizontalSpaceMedium(context),
                          vertical: 16,
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
                  : viewModel.memes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: kcPrimaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: kcPrimaryColor,
                                  size: 48,
                                ),
                              ),
                              verticalSpaceMedium,
                              Text(
                                'Search or use voice to find',
                                style: AppTextStyles.subheading(context,
                                    color: Colors.white70),
                              ),
                              verticalSpaceTiny,
                              Text(
                                'the perfect reaction',
                                style: AppTextStyles.subheading(context,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                getResponsiveHorizontalSpaceMedium(context),
                            vertical: 16,
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
                                  viewModel.toggleFavorite(meme.id),
                              isFavorite: viewModel.isFavorite(meme.id),
                            );
                          },
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

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/common/meme_card.dart';
import 'package:memeic/ui/views/search/widgets/search_bar_widget.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcAppBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  // App Branding
                  Row(
                    children: [
                      Text(
                        'Memeic',
                        style: AppTextStyles.headline(context,
                            color: Colors.white),
                      ),
                      horizontalSpaceSmall,
                      const FaIcon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: kcPrimaryColor,
                        size: 24,
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  // Search Bar
                  SearchBarWidget(
                    controller: viewModel.searchController,
                    onChanged: viewModel.onSearchChanged,
                    onVoiceSearch: viewModel.onVoiceSearch,
                    onTap: viewModel.onSearchBarTapped,
                    hintText: 'Search memes...',
                  ),
                  verticalSpaceMedium,
                  // Mood Chips Row
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: false,
                      itemCount: viewModel.moodChips.length,
                      separatorBuilder: (context, index) => horizontalSpaceTiny,
                      itemBuilder: (context, index) {
                        final mood = viewModel.moodChips[index];
                        final isSelected = viewModel.selectedMoodIndex == index;
                        return GestureDetector(
                          onTap: () => viewModel.selectMood(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? kcPrimaryColor : kcDarkGreyColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(186, 90, 41, 124),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (mood.emoji.isNotEmpty) ...[
                                  Text(
                                    mood.emoji,
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  mood.label,
                                  style: AppTextStyles.body(context,
                                      color: isSelected
                                          ? Colors.white
                                          : kcPrimaryColorLight),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceSmall,
            // Meme Grid
            Expanded(
              child: viewModel.isLoading
                  ? Skeletonizer(
                      enabled: true,
                      child: MasonryGridView.count(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              getResponsiveHorizontalSpaceSmall(context),
                          vertical: 16,
                        ),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final heightMultiplier =
                              viewModel.getMemeHeightMultiplier(index);
                          return SizedBox(
                            height: 250 * heightMultiplier,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kcMediumGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : MasonryGridView.count(
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsiveHorizontalSpaceSmall(context),
                        vertical: 16,
                      ),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: viewModel.trendingMemes.length,
                      itemBuilder: (context, index) {
                        final meme = viewModel.trendingMemes[index];
                        final heightMultiplier =
                            viewModel.getMemeHeightMultiplier(index);
                        return SizedBox(
                          height: 250 * heightMultiplier,
                          child: MemeCard(
                            imageUrl: meme.imageUrl,
                            title: meme.title,
                            tags: meme.tags,
                            heroTag: 'meme_${meme.id}',
                            onTap: () => viewModel.onMemePressed(meme),
                          ),
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
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}

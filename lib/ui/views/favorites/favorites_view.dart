import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/common/meme_card.dart';

import 'favorites_viewmodel.dart';

class FavoritesView extends StackedView<FavoritesViewModel> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FavoritesViewModel viewModel,
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
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 24,
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Favorites',
                        style: AppTextStyles.headline(context,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  verticalSpaceTiny,
                  Text(
                    '${viewModel.favoriteMemes.length} saved memes',
                    style:
                        AppTextStyles.caption(context, color: Colors.white70),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: viewModel.favoriteMemes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.red,
                              size: 48,
                            ),
                          ),
                          verticalSpaceMedium,
                          Text(
                            'No favorites yet',
                            style: AppTextStyles.heading3(context,
                                color: Colors.white),
                          ),
                          verticalSpaceTiny,
                          Text(
                            'Start saving your favorite memes',
                            style: AppTextStyles.caption(context,
                                color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: viewModel.favoriteMemes.length,
                      itemBuilder: (context, index) {
                        final meme = viewModel.favoriteMemes[index];
                        return MemeCard(
                          imageUrl: meme.imageUrl,
                          onTap: () => viewModel.onMemePressed(meme),
                          onFavorite: () => viewModel.toggleFavorite(meme.id),
                          isFavorite: true,
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
  FavoritesViewModel viewModelBuilder(BuildContext context) =>
      FavoritesViewModel();
}

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';

import 'main_navigation_viewmodel.dart';

class MainNavigationView extends StackedView<MainNavigationViewModel> {
  const MainNavigationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MainNavigationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: viewModel.currentView,
      bottomNavigationBar: Container(
        color: kcVeryDarkBackgroundColor,
        constraints: const BoxConstraints(minHeight: 90),
        child: GNav(
          backgroundColor: kcVeryDarkBackgroundColor,
          color: Colors.white54,
          activeColor: kcPrimaryColor,
          tabBackgroundColor: kcPrimaryColor.withValues(alpha: 0.1),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          tabs: const [
            GButton(
              icon: FontAwesomeIcons.house,
              text: 'Home',
            ),
            GButton(
              icon: FontAwesomeIcons.magnifyingGlass,
              text: 'Search',
            ),
            GButton(
              icon: FontAwesomeIcons.heart,
              text: 'Favorites',
            ),
            GButton(
              icon: FontAwesomeIcons.gear,
              text: 'Settings',
            ),
          ],
          selectedIndex: viewModel.currentIndex,
          onTabChange: (index) => viewModel.setIndex(index),
        ),
      ),
    );
  }

  @override
  MainNavigationViewModel viewModelBuilder(BuildContext context) =>
      MainNavigationViewModel();
}

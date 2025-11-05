import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
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
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: viewModel.homeView,
          item: ItemConfig(
            icon: const FaIcon(FontAwesomeIcons.house),
            title: "Home",
            activeForegroundColor: kcPrimaryColor,
            inactiveForegroundColor: Colors.white54,
          ),
        ),
        PersistentTabConfig(
          screen: viewModel.searchView,
          item: ItemConfig(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            title: "Search",
            activeForegroundColor: kcPrimaryColor,
            inactiveForegroundColor: Colors.white54,
          ),
        ),
        PersistentTabConfig(
          screen: viewModel.favoritesView,
          item: ItemConfig(
            icon: const FaIcon(FontAwesomeIcons.heart),
            title: "Favorites",
            activeForegroundColor: kcPrimaryColor,
            inactiveForegroundColor: Colors.white54,
          ),
        ),
        PersistentTabConfig(
          screen: viewModel.settingsView,
          item: ItemConfig(
            icon: const FaIcon(FontAwesomeIcons.gear),
            title: "Settings",
            activeForegroundColor: kcPrimaryColor,
            inactiveForegroundColor: Colors.white54,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => ClipRect(
        child: Container(
          color: kcVeryDarkBackgroundColor,
          child: Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: const NavBarDecoration(
              color: kcVeryDarkBackgroundColor,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }

  @override
  MainNavigationViewModel viewModelBuilder(BuildContext context) =>
      MainNavigationViewModel();
}

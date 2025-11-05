import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/views/settings/widgets/settings_tile.dart';
import 'package:memeic/ui/views/settings/widgets/settings_section.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcAppBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTextStyles.headline(context, color: Colors.white),
              ),
              verticalSpaceMedium,
              // User Profile Section
              GestureDetector(
                onTap: viewModel.onProfilePressed,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kcDarkGreyColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(186, 90, 41, 124),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 46, 34, 51),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.user,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      horizontalSpaceMedium,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.userName,
                              style: AppTextStyles.heading3(context,
                                  color: Colors.white),
                            ),
                            verticalSpaceTiny,
                            Text(
                              'Tap to create profile',
                              style: AppTextStyles.caption(context,
                                  color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                      const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpaceMedium,
              // Preferences Section
              SettingsSection(
                title: 'Preferences',
                children: [
                  SettingsTile(
                    icon: FontAwesomeIcons.moon,
                    title: 'Dark Mode',
                    subtitle: 'Always enabled',
                    trailing: Switch(
                      value: viewModel.isDarkMode,
                      onChanged: viewModel.toggleDarkMode,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.bell,
                    title: 'Notifications',
                    subtitle: 'Get meme updates',
                    trailing: Switch(
                      value: viewModel.notificationsEnabled,
                      onChanged: viewModel.toggleNotifications,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.bolt,
                    title: 'AI Suggestions',
                    subtitle: 'Smart recommendations',
                    trailing: Switch(
                      value: viewModel.aiSuggestionsEnabled,
                      onChanged: viewModel.toggleAiSuggestions,
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              // General Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'General',
                    style:
                        AppTextStyles.caption(context, color: Colors.white54),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kcDarkGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Preview',
                      style:
                          AppTextStyles.caption(context, color: Colors.white),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              SettingsSection(
                title: '',
                children: [
                  SettingsTile(
                    icon: FontAwesomeIcons.globe,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: viewModel.onLanguagePressed,
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.shield,
                    title: 'Privacy & Safety',
                    subtitle: 'Manage your data',
                    onTap: viewModel.onPrivacyPressed,
                  ),
                ],
              ),
              verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();
}

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
          padding: EdgeInsets.symmetric(
            horizontal: getResponsiveHorizontalSpaceMedium(context),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kcDarkGreyColor,
                  borderRadius: BorderRadius.circular(12),
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
                      decoration: const BoxDecoration(
                        color: kcPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                          size: 28,
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
                      activeThumbColor: kcPrimaryColor,
                    ),
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.bell,
                    title: 'Notifications',
                    subtitle: 'Get meme updates',
                    trailing: Switch(
                      value: viewModel.notificationsEnabled,
                      onChanged: viewModel.toggleNotifications,
                      activeThumbColor: kcPrimaryColor,
                    ),
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.wandMagicSparkles,
                    title: 'AI Suggestions',
                    subtitle: 'Smart recommendations',
                    trailing: Switch(
                      value: viewModel.aiSuggestionsEnabled,
                      onChanged: viewModel.toggleAiSuggestions,
                      activeThumbColor: kcPrimaryColor,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              // General Section
              SettingsSection(
                title: 'General',
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
              // Support Section
              SettingsSection(
                title: 'Support',
                children: [
                  SettingsTile(
                    icon: FontAwesomeIcons.circleInfo,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: viewModel.onAboutPressed,
                  ),
                  SettingsTile(
                    icon: FontAwesomeIcons.commentDots,
                    title: 'Send Feedback',
                    subtitle: 'Help us improve',
                    onTap: viewModel.onFeedbackPressed,
                  ),
                ],
              ),
              verticalSpaceMedium,
              // Sign Out Button
              GestureDetector(
                onTap: viewModel.onSignOut,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(186, 90, 41, 124),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: kcPrimaryColor,
                        size: 18,
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Sign Out',
                        style: AppTextStyles.heading3(context,
                            color: kcPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpaceSmall,
              // Reset Onboarding Button
              GestureDetector(
                onTap: viewModel.onResetOnboarding,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.arrowsRotate,
                        color: Colors.white54,
                        size: 16,
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Reset Onboarding',
                        style: AppTextStyles.caption(context,
                            color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpaceMedium,
              Center(
                child: Column(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.wandMagicSparkles,
                      color: kcPrimaryColor,
                      size: 24,
                    ),
                    verticalSpaceTiny,
                    Text(
                      'Made with magic',
                      style:
                          AppTextStyles.caption(context, color: kcPrimaryColor),
                    ),
                    verticalSpaceTiny,
                    Text(
                      '© 2025 Memeic • Version 1.0.0',
                      style:
                          AppTextStyles.caption(context, color: Colors.white54),
                    ),
                  ],
                ),
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

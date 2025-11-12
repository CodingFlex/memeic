import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/box_button2.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:memeic/ui/common/loading_overlay.dart';

import 'onboardingauth_viewmodel.dart';

class OnboardingauthView extends StackedView<OnboardingauthViewModel> {
  const OnboardingauthView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardingauthViewModel viewModel,
    Widget? child,
  ) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kcAppBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: getResponsiveHorizontalSpaceMedium(context),
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  verticalSpace(24),
                  Text(
                    'Memeic',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headline(context, color: Colors.white),
                  ),
                  verticalSpaceSmall,
                  Text(
                    'Your AI-powered meme & reaction finder',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.subheading(context, color: Colors.white),
                  ),
                  verticalSpaceMedium,
                  const _Bullet(
                      icon: FontAwesomeIcons.magnifyingGlass,
                      label: 'Discover Perfect Memes',
                      color: Color(0xFF4A90E2)), // Blue for search
                  verticalSpaceSmall,
                  const _Bullet(
                      icon: FontAwesomeIcons.bolt,
                      label: 'AI-Powered',
                      color: Color(0xFFFFC107)), // Amber/yellow for AI
                  verticalSpaceSmall,
                  const _Bullet(
                      icon: FontAwesomeIcons.heart,
                      label: 'Save & Share',
                      color: Color(0xFFE91E63)), // Pink/red for love
                  verticalSpaceMedium,
                  Text(
                    'Sign in to sync favorites',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subheading(context,
                        color: Colors.white70),
                  ),
                  verticalSpace(16.0),
                  // Google button (white background)
                  BoxButton2(
                    title: 'Continue with Google',
                    color: Colors.white,
                    textColor: Colors.black,
                    outlineColor: Colors.transparent,
                    height: 56,
                    leading: SvgPicture.asset(
                      'assets/svg/google.svg',
                      width: 20,
                      height: 20,
                    ),
                    onTap: viewModel.onGoogleTapped,
                  ),
                  verticalSpaceSmall,
                  // Apple button (dark)
                  BoxButton2(
                    title: 'Continue with Apple',
                    color: const Color.fromARGB(166, 34, 39, 51),
                    textColor: Colors.white,
                    outlineColor: const Color.fromARGB(186, 90, 41, 124),
                    height: 56,
                    leading: SvgPicture.asset(
                      'assets/svg/apple.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onTap: viewModel.onAppleTapped,
                  ),
                  verticalSpaceSmall,
                  // Email button (primary)
                  BoxButton2(
                    title: 'Continue with Email',
                    height: 56,
                    color: const Color.fromARGB(166, 34, 39, 51),
                    textColor: Colors.white,
                    outlineColor: const Color.fromARGB(186, 90, 41, 124),
                    leading: const FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: viewModel.onEmailTapped,
                  ),
                  verticalSpace(16.0),
                  Row(
                    children: [
                      Expanded(
                          child: Container(height: 1, color: Colors.white12)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or',
                          style: AppTextStyles.caption(context,
                              color: Colors.white54),
                        ),
                      ),
                      Expanded(
                          child: Container(height: 1, color: Colors.white12)),
                    ],
                  ),
                  verticalSpaceSmall,
                  // Guest button (outlined)
                  BoxButton2(
                    title: 'Continue as Guest',
                    color: Colors.transparent,
                    outlineColor: const Color.fromARGB(255, 89, 41, 124),
                    textColor: Colors.white,
                    height: 56,
                    onTap: viewModel.onGuestTapped,
                  ),
                  verticalSpace(16.0),
                  Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.caption(context, color: Colors.white54),
                  ),
                  verticalSpace(24),
                ],
              ),
            ),
          ),
        ),
        if (viewModel.isOAuthBusy) const LoadingOverlay(),
      ],
    );
  }

  @override
  OnboardingauthViewModel viewModelBuilder(BuildContext context) =>
      OnboardingauthViewModel();
}

class _Bullet extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Bullet({
    required this.icon,
    required this.label,
    this.color = kcPrimaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, color: color, size: 20),
        horizontalSpaceSmall,
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.subheading(context, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

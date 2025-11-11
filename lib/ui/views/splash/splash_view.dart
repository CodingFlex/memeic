import 'package:flutter/material.dart';
import 'package:memeic/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'splash_viewmodel.dart';

class SplashView extends StackedView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SplashViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcAppBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedMemeicText(),
            verticalSpaceMedium,
            const SpinKitFadingFour(
              color: kcPrimaryColor,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) {
    final viewModel = SplashViewModel();
    viewModel.initialize();
    return viewModel;
  }
}

class _AnimatedMemeicText extends StatefulWidget {
  @override
  State<_AnimatedMemeicText> createState() => _AnimatedMemeicTextState();
}

class _AnimatedMemeicTextState extends State<_AnimatedMemeicText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Text(
              'Memeic',
              style: AppTextStyles.headline(
                context,
                color: Colors.white,
              ).copyWith(fontSize: 30.sp, fontWeight: FontWeight.w900),
            ),
          ),
        );
      },
    );
  }
}

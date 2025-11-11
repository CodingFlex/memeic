import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memeic/ui/common/app_colors.dart';

/// A reusable loading overlay widget that can be used to show
/// busy states over any screen.
///
/// Usage:
/// ```dart
/// if (viewModel.isBusy || viewModel.busy('someKey'))
///   LoadingOverlay()
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Optional message to display below the spinner
  final String? message;

  /// Optional background color. Defaults to semi-transparent black.
  final Color? backgroundColor;

  /// Optional spinner color. Defaults to primary color.
  final Color? spinnerColor;

  /// Optional spinner size. Defaults to 50.0
  final double? size;

  const LoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.spinnerColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: backgroundColor ?? Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitFadingFour(
                color: spinnerColor ?? kcPrimaryColor,
                size: size ?? 50.0,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:memeic/ui/common/app_colors.dart';

enum ButtonType { primary, secondary, danger }

enum ButtonState { enabled, disabled, loading }

class BoxButton extends StatelessWidget {
  final String title;
  final ButtonType type;
  final ButtonState state;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final double width;
  final double height;
  final Color? color;
  final TextStyle? textStyle;
  final double borderRadius;

  const BoxButton({
    super.key,
    required this.title,
    this.type = ButtonType.primary,
    this.state = ButtonState.enabled,
    this.onTap,
    this.color,
    this.leading,
    this.width = double.infinity,
    this.height = 45.0,
    this.textStyle,
    this.borderRadius = 6.0,
  }) : outline = false;

  const BoxButton.outline({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.color,
    this.textStyle,
    required this.height,
    required this.width,
    this.borderRadius = 6.0,
    this.type = ButtonType.primary,
    this.state = ButtonState.enabled,
  }) : outline = true;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = () {
      if (color != null) return color!;
      switch (type) {
        case ButtonType.primary:
          return kcPrimaryColor;
        case ButtonType.secondary:
          return kcDarkGreyColor;
        case ButtonType.danger:
          return const Color(0xFFD42620);
      }
    }();

    final bool isDisabled = state == ButtonState.disabled;
    final bool isLoading = state == ButtonState.loading;
    final Color fillColor = outline
        ? Colors.transparent
        : (isDisabled ? baseColor.withOpacity(0.4) : baseColor);
    final Color borderColor = baseColor;
    final Color labelColor = outline ? baseColor : Colors.white;

    return GestureDetector(
      onTap: state != ButtonState.disabled && state != ButtonState.loading
          ? () {
              // Haptic feedback tuned by type
              if (type == ButtonType.danger) {
                HapticFeedback.heavyImpact();
              } else {
                HapticFeedback.selectionClick();
              }
              onTap?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: !outline
            ? BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: 1),
              ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: state == ButtonState.enabled ? onTap : null,
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: !isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leading != null) leading!,
                        if (leading != null) const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            state == ButtonState.loading
                                ? 'Processing...'
                                : title,
                            style: textStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: outline
                                          ? FontWeight.w500
                                          : FontWeight.bold,
                                      color: labelColor,
                                      fontSize: 16.0,
                                    ),
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoActivityIndicator(radius: 10.0),
                        SizedBox(width: 8),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

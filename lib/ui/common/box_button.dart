import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:memeic/ui/common/app_colors.dart';

enum ButtonType { primary, secondary, danger }

enum ButtonState { enabled, disabled, loading }

class BoxButton extends StatefulWidget {
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
  State<BoxButton> createState() => _BoxButtonState();
}

class _BoxButtonState extends State<BoxButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = () {
      if (widget.color != null) return widget.color!;
      switch (widget.type) {
        case ButtonType.primary:
          return kcPrimaryColor;
        case ButtonType.secondary:
          return kcDarkGreyColor;
        case ButtonType.danger:
          return const Color(0xFFD42620);
      }
    }();

    final bool isDisabled = widget.state == ButtonState.disabled;
    final bool isLoading = widget.state == ButtonState.loading;
    final bool isEnabled = widget.state == ButtonState.enabled;
    final Color fillColor = widget.outline
        ? Colors.transparent
        : (isDisabled ? baseColor.withOpacity(0.4) : baseColor);
    final Color borderColor = baseColor;
    final Color labelColor = widget.outline ? baseColor : Colors.white;

    return GestureDetector(
      onTapDown: isEnabled
          ? (_) {
              setState(() {
                _isPressed = true;
              });
            }
          : null,
      onTapUp: isEnabled
          ? (_) {
              // Reset pressed state immediately
              Future.microtask(() {
                if (mounted) {
                  setState(() {
                    _isPressed = false;
                  });
                }
              });
            }
          : null,
      onTapCancel: isEnabled
          ? () {
              setState(() {
                _isPressed = false;
              });
            }
          : null,
      onTap: isEnabled
          ? () {
              // Haptic feedback tuned by type
              if (widget.type == ButtonType.danger) {
                HapticFeedback.heavyImpact();
              } else {
                HapticFeedback.selectionClick();
              }
              widget.onTap?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.96 : 1.0)
          ..translate(0.0, _isPressed ? 2.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: !widget.outline
              ? BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: borderColor, width: 1),
                ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              onTap: isEnabled
                  ? () {
                      // Haptic feedback tuned by type
                      if (widget.type == ButtonType.danger) {
                        HapticFeedback.heavyImpact();
                      } else {
                        HapticFeedback.selectionClick();
                      }
                      widget.onTap?.call();
                    }
                  : null,
              child: Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                child: !isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.leading != null) widget.leading!,
                          if (widget.leading != null) const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              widget.state == ButtonState.loading
                                  ? 'Processing...'
                                  : widget.title,
                              style: widget.textStyle ??
                                  Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: widget.outline
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
      ),
    );
  }
}

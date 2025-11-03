import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';

enum Button2Type { primary, secondary, danger }

enum Button2State { enabled, disabled, loading }

class BoxButton2 extends StatelessWidget {
  final String title;
  final Button2Type type;
  final Button2State state;
  final void Function()? onTap;
  final Widget? leading;
  final double width;
  final double height;
  final Color? color;
  final TextStyle? textStyle;
  final Color? outlineColor; // Optional override for outline color
  final Color? textColor; // Optional override for text color
  final double borderRadius; // Border radius
  final bool isDelete; // Deprecated: use type == danger
  final bool noBorder; // Remove border
  final bool noShadow; // Remove shadow

  const BoxButton2({
    super.key,
    required this.title,
    this.type = Button2Type.primary,
    this.state = Button2State.enabled,
    this.onTap,
    this.leading,
    this.width = double.infinity,
    this.height = 45.0,
    this.textStyle,
    this.color = Colors.transparent, // Default to transparent
    this.outlineColor, // Fallbacks handled below
    this.textColor, // Fallbacks handled below
    this.borderRadius = 16.0,
    this.isDelete = false,
    this.noBorder = false,
    this.noShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    // Define delete styling
    const Color deleteOutlineColor = Colors.red;
    const Color deleteTextColor = Colors.red;

    // Determine base color from type if color not provided
    final Color baseColor = color ??
        () {
          switch (isDelete ? Button2Type.danger : type) {
            case Button2Type.primary:
              return kcPrimaryColor;
            case Button2Type.secondary:
              return kcDarkGreyColor;
            case Button2Type.danger:
              return deleteOutlineColor;
          }
        }();

    final bool isDisabled = state == Button2State.disabled;
    final bool isLoading = state == Button2State.loading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.white, // Keep existing default behavior
        borderRadius: BorderRadius.circular(
          borderRadius,
        ), // Use the provided border radius
        border: noBorder
            ? null // No border if noBorder is true
            : (outlineColor == null && textColor == null)
                ? null // No border if both are null
                : Border.all(
                    color: isDelete
                        ? deleteOutlineColor
                        : isDisabled
                            ? kcMediumGrey
                            : (outlineColor ?? baseColor),
                    width: 1,
                  ),
        // Add shadow when color is white for better visibility in light mode, unless noShadow is true
        boxShadow: noShadow
            ? null
            : (color == Colors.white
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ]
                : null),
      ),
      child: Material(
        color: Colors.transparent, // Make the Material widget transparent
        child: InkWell(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ), // Match the button's border radius
          onTap: (state == Button2State.enabled) ? onTap : null,
          splashColor: kcPrimaryColor.withOpacity(
            0.1,
          ), // Disable tap if button is disabled or busy
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
                          state == Button2State.loading
                              ? 'Processing...'
                              : title,
                          style: textStyle ??
                              AppTextStyles.heading3(context).copyWith(
                                fontSize: 16.sp,
                                fontWeight:
                                    FontWeight.w700, // Default font weight
                                color: isDelete
                                    ? deleteTextColor
                                    : isDisabled
                                        ? kcMediumGrey
                                        : (textColor ??
                                            (outlineColor == null &&
                                                    textColor == null
                                                ? Colors.black
                                                : baseColor)),
                              ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 20, // Set the desired height
                    width: 20, // Set the desired width
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation(
                        isDelete ? Colors.red : baseColor,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

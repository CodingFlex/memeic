import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';

class MoodChip extends StatelessWidget {
  final String emoji;
  final String label;
  final int? percentage;
  final VoidCallback onTap;

  const MoodChip({
    Key? key,
    required this.emoji,
    required this.label,
    this.percentage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kcDarkGreyColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(186, 90, 41, 124),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 16.sp),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption(context, color: Colors.white),
            ),
            if (percentage != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kcPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$percentage%',
                  style: AppTextStyles.caption(context, color: kcPrimaryColor)
                      .copyWith(fontSize: 10.sp),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

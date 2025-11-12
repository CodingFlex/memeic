import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class TrendingMoodItem extends StatelessWidget {
  final String emoji;
  final String label;
  final int percentage;
  final VoidCallback onTap;

  const TrendingMoodItem({
    Key? key,
    required this.emoji,
    required this.label,
    required this.percentage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kcDarkGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 24.sp),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body(context, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$percentage%',
                style: AppTextStyles.caption(context, color: Colors.white)
                    .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

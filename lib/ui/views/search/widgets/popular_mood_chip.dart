import 'package:flutter/material.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class PopularMoodChip extends StatelessWidget {
  final String label;
  final String emoji;
  final int? count;
  final VoidCallback onTap;

  const PopularMoodChip({
    super.key,
    required this.label,
    required this.emoji,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kcDarkGreyColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: kcMediumGrey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji.isNotEmpty) ...[
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              horizontalSpaceTiny,
            ],
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.body(context, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (count != null && count! > 0) ...[
              horizontalSpaceTiny,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kcPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: AppTextStyles.caption(
                    context,
                    color: kcPrimaryColorLight,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

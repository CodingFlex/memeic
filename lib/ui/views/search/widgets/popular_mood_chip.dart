import 'package:flutter/material.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';

class PopularMoodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PopularMoodChip({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kcDarkGreyColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.body(context, color: Colors.white),
        ),
      ),
    );
  }
}


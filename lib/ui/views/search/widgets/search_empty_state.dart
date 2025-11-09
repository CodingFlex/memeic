import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class SearchEmptyState extends StatelessWidget {
  final VoidCallback? onPreviewTap;

  const SearchEmptyState({
    Key? key,
    this.onPreviewTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPreviewTap,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.star,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
          verticalSpaceMedium,
          Text(
            'Search or use voice to find the perfect reaction',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(context, color: Colors.white),
          ),
          verticalSpaceSmall,
          if (onPreviewTap != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kcMediumGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Preview',
                style: AppTextStyles.caption(context, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}


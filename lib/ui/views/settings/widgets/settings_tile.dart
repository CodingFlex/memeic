import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kcDarkGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: kcPrimaryColor,
                  size: 18,
                ),
              ),
            ),
            horizontalSpaceSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body(context, color: Colors.white),
                  ),
                  verticalSpaceTiny,
                  Text(
                    subtitle,
                    style:
                        AppTextStyles.caption(context, color: Colors.white54),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white54,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

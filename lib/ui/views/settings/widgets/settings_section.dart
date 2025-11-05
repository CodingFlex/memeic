import 'package:flutter/material.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption(context, color: Colors.white54),
        ),
        verticalSpaceSmall,
        Container(
          decoration: BoxDecoration(
            color: kcDarkGreyColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(186, 90, 41, 124),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

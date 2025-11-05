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
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: AppTextStyles.caption(context, color: Colors.white54),
          ),
          verticalSpaceSmall,
        ],
        Container(
          decoration: BoxDecoration(
            color: kcDarkGreyColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromARGB(186, 90, 41, 124),
              width: 1,
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final widget = entry.value;
              final isLast = index == children.length - 1;

              return Column(
                children: [
                  widget,
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromARGB(186, 90, 41, 124),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

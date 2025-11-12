import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/ui_helpers.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onTap;
  final String hintText;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onVoiceSearch,
    this.onTap,
    this.hintText = 'Describe your mood...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kcDarkGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kcPrimaryColorLight.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.white,
            size: 18,
          ),
          horizontalSpaceSmall,
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap != null ? () => onTap!() : null,
              style: AppTextStyles.body(context, color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.body(context,
                    color: kcPrimaryColorLight.withValues(alpha: 0.7)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onVoiceSearch != null)
            GestureDetector(
              onTap: onVoiceSearch,
              child: const FaIcon(
                FontAwesomeIcons.microphone,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

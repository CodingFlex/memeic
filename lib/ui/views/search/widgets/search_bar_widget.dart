import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kcDarkGreyColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(186, 90, 41, 124),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white54,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: AppTextStyles.body(context, color: Colors.white),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyles.body(context, color: Colors.white54),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (onVoiceSearch != null)
              GestureDetector(
                onTap: onVoiceSearch,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const FaIcon(
                    FontAwesomeIcons.microphone,
                    color: Colors.white54,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

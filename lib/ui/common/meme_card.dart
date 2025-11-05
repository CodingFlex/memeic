import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:memeic/ui/common/app_colors.dart';
import 'package:memeic/ui/common/text_styles.dart';

class MemeCard extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final double? aspectRatio;
  final String? title;
  final List<String>? tags;
  final bool showPreview;
  final String? heroTag;

  const MemeCard({
    Key? key,
    required this.imageUrl,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.aspectRatio,
    this.title,
    this.tags,
    this.showPreview = false,
    this.heroTag,
  }) : super(key: key);

  @override
  State<MemeCard> createState() => _MemeCardState();
}

class _MemeCardState extends State<MemeCard> {
  bool _isPressed = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _isHovering = true;
          _isPressed = true;
        }),
        onExit: (_) => setState(() {
          _isHovering = false;
          _isPressed = false;
        }),
        child: Transform.scale(
          scale: _isPressed ? 0.98 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kcDarkGreyColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.heroTag != null)
                    Hero(
                      tag: widget.heroTag!,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: kcDarkGreyColor,
                          child: Skeletonizer(
                            enabled: true,
                            child: Container(
                              color: kcMediumGrey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: kcDarkGreyColor,
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.image,
                              color: kcMediumGrey,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: kcDarkGreyColor,
                        child: Skeletonizer(
                          enabled: true,
                          child: Container(
                            color: kcMediumGrey,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: kcDarkGreyColor,
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.image,
                            color: kcMediumGrey,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  // Overlay gradient at bottom - only show on hover
                  if (widget.title != null || widget.tags != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: (_isHovering || _isPressed) ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.title != null)
                                Text(
                                  widget.title!,
                                  style: AppTextStyles.body(context,
                                      color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (widget.tags != null &&
                                  widget.tags!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: widget.tags!.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: kcPrimaryColor.withValues(
                                            alpha: 0.40),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tag,
                                        style: AppTextStyles.caption(context,
                                                color: Colors.white)
                                            .copyWith(fontSize: 12.sp),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Favorite button at top right
                  if (widget.onFavorite != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: FaIcon(
                            widget.isFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color:
                                widget.isFavorite ? Colors.red : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  // Press/hover overlay effect
                  if (_isPressed)
                    Container(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

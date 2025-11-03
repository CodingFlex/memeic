import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:memeic/ui/common/text_styles.dart';
import 'package:memeic/ui/common/app_colors.dart';

/// A custom circle avatar widget that matches the unique design requirements.
///
/// This widget provides customizable styling with kcPrimaryColor as the default background color.
/// All avatars use white text for better contrast.
///
/// Usage examples:
/// ```dart
/// // For a regular user (creator) - uses kcPrimaryColor background
/// CustomCircleAvatar(
///   profileImageUrl: 'https://example.com/photo.jpg',
///   firstName: 'John',
///   email: 'john@example.com',
///   radius: 30,
/// )
///
/// // For an opponent with custom background color
/// CustomCircleAvatar(
///   username: 'opponent123',
///   email: 'opponent@example.com',
///   radius: 30,
///   isOpponent: true,
///   backgroundColor: Colors.orange,
/// )
///
/// // With custom background color
/// CustomCircleAvatar(
///   email: 'user@example.com',
///   backgroundColor: Colors.blue,
///   radius: 25,
/// )
/// ```
class CustomCircleAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final String? firstName;
  final String? email;
  final String? username;
  final double radius;
  final bool isOpponent;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CustomCircleAvatar({
    super.key,
    this.profileImageUrl,
    this.firstName,
    this.email,
    this.username,
    this.radius = 30,
    this.isOpponent = false,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getBackgroundColor(),
          border: Border.all(color: _getBorderColor(), width: 1.5),
        ),
        child: ClipOval(child: _buildAvatarContent(context)),
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    // If profile image exists, use it
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return Image.network(
        profileImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildTextAvatar(context);
        },
      );
    }

    // Otherwise, build text avatar
    return _buildTextAvatar(context);
  }

  Widget _buildTextAvatar(BuildContext context) {
    final displayText = _getDisplayText();
    final textColor = _getTextColor();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBackgroundColor(),
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTextStyles.body(context).copyWith(
            color: textColor,
            fontSize: (radius * 0.6).sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    // For opponent, try username first, then email
    if (isOpponent) {
      if (username != null && username!.isNotEmpty) {
        return username![0].toUpperCase();
      }
      if (email != null && email!.isNotEmpty) {
        return email![0].toUpperCase();
      }
      return '?';
    }

    // For creator/user, try firstName first, then email
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return '?';
  }

  Color _getBackgroundColor() {
    // If custom background color is provided, use it
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    // Default to kcPrimaryColor for all avatars
    return kcPrimaryColor;
  }

  Color _getBorderColor() {
    if (isOpponent) {
      // Opponent has a thin dark border
      return Colors.grey.withValues(alpha: 0.4);
    } else {
      // Creator has a white border
      return Colors.white.withValues(alpha: 0.5);
    }
  }

  Color _getTextColor() {
    // Default to white text for better contrast with kcPrimaryColor
    return Colors.white;
  }
}

// Extension for easy usage with existing user models
extension CustomCircleAvatarExtensions on CustomCircleAvatar {
  static CustomCircleAvatar fromUser({
    String? profileImageUrl,
    String? firstName,
    String? email,
    double radius = 30,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return CustomCircleAvatar(
      profileImageUrl: profileImageUrl,
      firstName: firstName,
      email: email,
      radius: radius,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  static CustomCircleAvatar forOpponent({
    String? profileImageUrl,
    String? username,
    String? email,
    double radius = 30,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return CustomCircleAvatar(
      profileImageUrl: profileImageUrl,
      username: username,
      email: email,
      radius: radius,
      isOpponent: true,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }
}

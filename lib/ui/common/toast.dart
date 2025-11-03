import 'package:flutter/material.dart';
import 'package:memeic/ui/common/text_styles.dart';

class ToastService {
  static void showSuccessToast({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Fallback SnackBar-based toast to avoid external deps
    _showSnack(
      message: message,
      backgroundColor: const Color(0xFF2F4F06),
      textColor: Colors.white,
      duration: duration,
    );
  }

  static void showErrorToast({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(
      message: message,
      backgroundColor: const Color(0xFF630B0B),
      textColor: Colors.white,
      duration: duration,
    );
  }

  static void showAddBankSuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(
      message: message,
      backgroundColor: const Color(0xFFE7F6EC),
      textColor: const Color(0xFF04802E),
      duration: duration,
    );
  }

  static void showCopySuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(
      message: message,
      backgroundColor: const Color(0xFFE7F6EC),
      textColor: const Color(0xFF04802E),
      duration: duration,
    );
  }

  static void showComingSoon({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnack(
      message: message,
      backgroundColor: const Color(0xFFE7F6EC),
      textColor: const Color(0xFF04802E),
      duration: duration,
    );
  }

  static void _showSnack({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Duration duration,
  }) {
    final ctx = _rootContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          duration: duration,
          content: Text(
            message,
            style: AppTextStyles.body(ctx, color: textColor).copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

// Provide a way to set a root context for toasts without passing BuildContext
BuildContext? _rootContext;
void setToastRootContext(BuildContext context) {
  _rootContext = context;
}

import 'package:intl/intl.dart';

/// A robust parser utility that converts many input shapes to a double.
///
/// - Accepts String, int, double, num and returns a double.
/// - Handles currency symbols, thousand separators, mixed separators ("," and "."),
///   whitespace, and negative values.
/// - Falls back to [defaultValue] when parsing fails.
class ValueParser {
  /// Converts [value] to double using best-effort heuristics.
  ///
  /// Examples it can parse:
  /// - "5,000" → 5000.0
  /// - "₦5,000.25" → 5000.25
  /// - "5.000,25" (EU style) → 5000.25
  /// - "(1,234.50)" → -1234.5
  /// - 1234 → 1234.0
  static double toDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      final result = _parseStringToDouble(value);
      return result ?? defaultValue;
    }
    // Unsupported type
    return defaultValue;
  }

  /// Tries to parse a [String] to double applying normalization and separator rules.
  static double? _parseStringToDouble(String input) {
    if (input.trim().isEmpty) return null;

    String s = input.trim();

    // Handle negatives with parentheses e.g. (1,234.56)
    bool isNegative = false;
    if (s.startsWith('(') && s.endsWith(')')) {
      isNegative = true;
      s = s.substring(1, s.length - 1);
    }

    // Remove currency symbols and letters; keep digits, separators, signs
    s = s.replaceAll(RegExp(r'[^0-9,\.\-\+ ]'), '');
    s = s.replaceAll(' ', '');

    // If it's now empty or just a sign, fail
    if (s.isEmpty || s == '-' || s == '+') return null;

    // Decide decimal separator when both are present
    final hasDot = s.contains('.');
    final hasComma = s.contains(',');

    if (hasDot && hasComma) {
      final lastDot = s.lastIndexOf('.');
      final lastComma = s.lastIndexOf(',');
      final decimalSep = lastComma > lastDot ? ',' : '.';
      if (decimalSep == ',') {
        // comma is decimal → remove dots (thousands), replace commas with dot
        s = s.replaceAll('.', '');
        s = s.replaceAll(',', '.');
      } else {
        // dot is decimal → remove commas (thousands)
        s = s.replaceAll(',', '');
      }
    } else if (hasComma && !hasDot) {
      // Only commas present: decide if decimal or thousands
      final parts = s.split(',');
      if (parts.length == 2 && parts[1].length <= 2) {
        // Likely decimal
        s = s.replaceAll(',', '.');
      } else {
        // Likely thousands-separated
        s = s.replaceAll(',', '');
      }
    } // else only dot or neither → parse directly

    // One last sanity: keep only one leading sign
    s = s.replaceAll(RegExp(r'(?<=.)[\+\-]'), '');

    final parsed = double.tryParse(s);
    if (parsed == null) return null;
    return isNegative ? -parsed : parsed;
  }

  /// Formats a numeric [value] with grouping using the current locale.
  /// Useful companion to [toDouble] when rendering.
  static String formatWithCommas(num value, {int? decimalDigits}) {
    final formatter = NumberFormat.decimalPattern();
    if (decimalDigits != null) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }
    return formatter.format(value);
  }
}

import 'package:flutter/material.dart';
// Removed google_fonts dependency for lints

class AppTextStyles {
  static TextStyle heading1(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w600,
        fontSize: 28,
        color: color ?? _textColor(context),
      );
  static TextStyle heading1Red(BuildContext context, {Color? color}) =>
      TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w800,
        fontSize: 28,
        color: color ?? _textColor(context),
      );
  static TextStyle headingReciept(BuildContext context, {Color? color}) =>
      TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w500,
        fontSize: 28,
        color: color ?? _textColor(context),
      );
  static TextStyle fieldFont(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w300,
        fontSize: 20,
        color: color ?? _textColor(context),
      );

  static TextStyle heading2(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: color ?? _textColor(context),
      );

  static TextStyle heading3(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: color ?? _textColor(context),
      );

  static TextStyle moneyFont(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: color ?? _textColor(context),
      );

  static TextStyle moneyFellix(BuildContext context, {Color? color}) =>
      TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w600,
        fontSize: 30,
        color: color ?? _textColor(context),
      );

  static TextStyle headline(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w800,
        fontSize: 30,
        color: color ?? _textColor(context),
      );

  static TextStyle subheading(BuildContext context, {Color? color}) =>
      TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: color ?? _textColor(context),
      );

  static TextStyle caption(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: color ?? _textColor(context),
      );

  static TextStyle body(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: 'Fellix',
        fontFamilyFallback: const ['Arial', 'sans-serif'],
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: color ?? _textColor(context),
      );

  static Color _textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}

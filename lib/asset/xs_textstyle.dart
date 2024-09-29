import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

TextStyle XSTextStyle({
  required BuildContext context,
  bool listenProvider = true,
  bool inherit = true,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  TextLeadingDistribution? leadingDistribution,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  List<FontVariation>? fontVariations,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
  String? debugLabel,
  String? fontFamily,
  List<String>? fontFamilyFallback,
  String? package,
  TextOverflow? overflow,
}) {
  var _provider =
      Provider.of<FontSizeProvider>(context, listen: listenProvider);
  final List<String> fallbackFonts = [
    'Noto Sans CJK',
    'Helvetica Neue',
    'San Francisco',
    'Arial',
    'Open Sans',
    'Roboto',
  ];
  return TextStyle(
    inherit: inherit,
    height: height,
    fontSize: fontSize == null ? fontSize : fontSize * _provider.fraction,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    leadingDistribution: leadingDistribution,
    locale: locale,
    foreground: foreground,
    background: background,
    shadows: shadows,
    fontFeatures: fontFeatures,
    fontVariations: fontVariations,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
    debugLabel: debugLabel,
    fontFamily: fontFamily ?? "",
    fontFamilyFallback: fontFamilyFallback,
    overflow: overflow,
  );
}

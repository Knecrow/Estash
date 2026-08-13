import 'package:flutter/material.dart';

abstract class AppConstants {
  static const double cardRadius = 22.0;
  static const double pagePadding = 16.0;
  static const double cardGap = 12.0;

  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 400);

  static const BorderRadius squircleRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );
}

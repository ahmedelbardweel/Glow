import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double buttonRadiusValue = 50.0; // Action button.
  static const double cardRadiusValue = 50.0;
  static const double inputRadiusValue = 50.0;
  static const double badgeRadiusValue = 50.0;
  static const double globalValue = 50.0;

  // Action button.
  static BorderRadius get button => BorderRadius.circular(buttonRadiusValue);
  static OutlinedBorder get buttonShape => RoundedRectangleBorder(borderRadius: button);

  // Information card.
  static BorderRadius get card => BorderRadius.circular(cardRadiusValue);
  static OutlinedBorder get cardShape => RoundedRectangleBorder(borderRadius: card);

  static BorderRadius get input => BorderRadius.circular(inputRadiusValue);

  static BorderRadius get badge => BorderRadius.circular(badgeRadiusValue);

  static BorderRadius get all => BorderRadius.circular(cardRadiusValue);
  static Radius get radius => const Radius.circular(cardRadiusValue);
  static OutlinedBorder get shape => RoundedRectangleBorder(borderRadius: all);
}

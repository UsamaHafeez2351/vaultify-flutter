import 'package:flutter/material.dart';

const String baseUrl = "http://192.168.18.79:3000"; // Your PC IP address for physical device
// Updated to current WiFi IP address. Change this if your IP changes.

const List<String> apiBasePaths = [
  "",       // No base path
  "/api",   // Common API base
  "/v1",    // Versioned API
  "/rest",  // Alternative base
];

// Light Theme Colors
const kPrimaryColorLight = Color(0xFF6C63FF);
const kSecondaryColorLight = Color(0xFF4CAF50);
const kAccentColorLight = Color(0xFFFF6584);
const kBackgroundColorLight = Color(0xFFF8F9FD);
const kCardColorLight = Color(0xFFFFFFFF);
const kTextColorLight = Color(0xFF2D3142);
const kTextSecondaryLight = Color(0xFF9FA5C0);

// Dark Theme Colors
const kPrimaryColorDark = Color(0xFF8B7FFF);
const kSecondaryColorDark = Color(0xFF66BB6A);
const kAccentColorDark = Color(0xFFFF7A9A);
const kBackgroundColorDark = Color(0xFF1A1A2E);
const kCardColorDark = Color(0xFF16213E);
const kTextColorDark = Color(0xFFEEEEEE);
const kTextSecondaryDark = Color(0xFFB0B3C1);

// Legacy colors for backward compatibility
const kPrimaryColor = Color(0xFF6C63FF);
const kAccentColor = Color(0xFF4CAF50);
const kBackgroundColor = Color(0xFFF8F9FD);

const kPadding = 16.0;

// Gradient Colors
final kGradientLight = [
  kPrimaryColorLight,
  kPrimaryColorLight.withOpacity(0.8),
  kSecondaryColorLight.withOpacity(0.6),
];

final kGradientDark = [
  kPrimaryColorDark,
  kPrimaryColorDark.withOpacity(0.8),
  kSecondaryColorDark.withOpacity(0.6),
];

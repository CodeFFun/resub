import 'package:flutter/material.dart';

/// Responsive utility class for scaling dimensions based on device size
///
/// This class provides methods to make UI components scalable across different
/// device sizes while maintaining design consistency.
class ResponsiveUtils {
  // Design reference dimensions (typically from design mockups)
  static const double _designWidth = 375.0; // iPhone SE/11 Pro width
  static const double _designHeight = 812.0; // iPhone SE/11 Pro height

  /// Get responsive width based on design width
  static double width(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (size / _designWidth) * screenWidth;
  }

  /// Get responsive height based on design height
  static double height(BuildContext context, double size) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (size / _designHeight) * screenHeight;
  }

  /// Get responsive font size
  /// Uses width for better text scaling
  static double fontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (size / _designWidth) * screenWidth;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (size / _designWidth) * screenWidth;
  }

  /// Get responsive border radius
  static double radius(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (size / _designWidth) * screenWidth;
  }

  /// Get responsive padding/margin
  static double spacing(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (size / _designWidth) * screenWidth;
  }

  /// Check if device is mobile (width < 600)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if device is tablet (600 <= width < 1200)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  /// Check if device is desktop (width >= 1200)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// Get responsive value based on device type
  /// Useful for different layouts on different screen sizes
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

/// Extension on BuildContext for easier access to responsive utils
extension ResponsiveExtension on BuildContext {
  /// Get responsive width
  double rWidth(double size) => ResponsiveUtils.width(this, size);

  /// Get responsive height
  double rHeight(double size) => ResponsiveUtils.height(this, size);

  /// Get responsive font size
  double rFont(double size) => ResponsiveUtils.fontSize(this, size);

  /// Get responsive icon size
  double rIcon(double size) => ResponsiveUtils.iconSize(this, size);

  /// Get responsive border radius
  double rRadius(double size) => ResponsiveUtils.radius(this, size);

  /// Get responsive spacing (padding/margin)
  double rSpacing(double size) => ResponsiveUtils.spacing(this, size);

  /// Check if mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Get screen width
  double get screenWidth => ResponsiveUtils.screenWidth(this);

  /// Get screen height
  double get screenHeight => ResponsiveUtils.screenHeight(this);

  /// Get responsive value based on device type
  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      ResponsiveUtils.responsive(
        context: this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}

// 🎨 موفر الثيمات - إدارة الألوان والثيمات الديناميكية
// يدير جميع الثيمات والألوان في التطبيق مع دعم Material Design 3

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../models/settings_models.dart';
import '../services/database_service.dart';
import '../constants/app_constants.dart';

/// 🎨 موفر الثيمات الرئيسي
class ThemeProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  // ⚙️ إعدادات التطبيق
  AppSettings _appSettings = AppSettings();

  // 🎨 الثيمات
  ThemeData? _lightTheme;
  ThemeData? _darkTheme;
  ColorScheme? _lightColorScheme;
  ColorScheme? _darkColorScheme;

  // 🌈 الألوان الديناميكية
  bool _supportsDynamicColor = false;
  ColorScheme? _dynamicLightColorScheme;
  ColorScheme? _dynamicDarkColorScheme;

  // Getters
  AppSettings get appSettings => _appSettings;
  ThemeData? get lightTheme => _lightTheme;
  ThemeData? get darkTheme => _darkTheme;
  bool get supportsDynamicColor => _supportsDynamicColor;

  /// 🚀 تهيئة موفر الثيمات
  Future<void> initialize() async {
    // تحميل الإعدادات
    _appSettings = _databaseService.getAppSettings();

    // فحص دعم الألوان الديناميكية
    await _checkDynamicColorSupport();

    // إنشاء الثيمات
    await _buildThemes();

    notifyListeners();
  }

  /// 🌈 فحص دعم الألوان الديناميكية
  Future<void> _checkDynamicColorSupport() async {
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();
      _supportsDynamicColor = corePalette != null;

      if (_supportsDynamicColor && _appSettings.useDynamicColors) {
        _dynamicLightColorScheme = await DynamicColorPlugin.getAccentColor()
            .then(
              (color) => color != null
                  ? ColorScheme.fromSeed(
                      seedColor: color,
                      brightness: Brightness.light,
                    )
                  : null,
            );

        _dynamicDarkColorScheme = await DynamicColorPlugin.getAccentColor()
            .then(
              (color) => color != null
                  ? ColorScheme.fromSeed(
                      seedColor: color,
                      brightness: Brightness.dark,
                    )
                  : null,
            );
      }
    } catch (e) {
      _supportsDynamicColor = false;
      debugPrint('خطأ في فحص الألوان الديناميكية: $e');
    }
  }

  /// 🏗️ بناء الثيمات
  Future<void> _buildThemes() async {
    // تحديد نظام الألوان
    _lightColorScheme = _getDynamicOrDefaultColorScheme(Brightness.light);
    _darkColorScheme = _getDynamicOrDefaultColorScheme(Brightness.dark);

    // بناء الثيم الفاتح
    _lightTheme = _buildTheme(
      colorScheme: _lightColorScheme!,
      brightness: Brightness.light,
    );

    // بناء الثيم الداكن
    _darkTheme = _buildTheme(
      colorScheme: _darkColorScheme!,
      brightness: Brightness.dark,
    );
  }

  /// 🌈 الحصول على نظام الألوان (ديناميكي أو افتراضي)
  ColorScheme _getDynamicOrDefaultColorScheme(Brightness brightness) {
    if (_appSettings.useDynamicColors && _supportsDynamicColor) {
      return brightness == Brightness.light
          ? _dynamicLightColorScheme ?? _getDefaultColorScheme(brightness)
          : _dynamicDarkColorScheme ?? _getDefaultColorScheme(brightness);
    }
    return _getDefaultColorScheme(brightness);
  }

  /// 🎨 الحصول على نظام الألوان الافتراضي
  ColorScheme _getDefaultColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: Color(AppConstants.primaryColorValue),
      brightness: brightness,
    );
  }

  /// 🏗️ بناء الثيم
  ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,

      // 📝 خطوط النصوص
      fontFamily: _appSettings.fontFamily,
      textTheme: _buildTextTheme(colorScheme, isDark),

      // 🎯 شريط التطبيق
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: _appSettings.fontSize + 4,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: _appSettings.fontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),

      // 🎴 البطاقات
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_appSettings.chatBubbleRadius),
        ),
        color: colorScheme.surfaceContainerHighest,
      ),

      // 🔘 الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: TextStyle(
            fontSize: _appSettings.fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: _appSettings.fontFamily,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: TextStyle(
            fontSize: _appSettings.fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: _appSettings.fontFamily,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: TextStyle(
            fontSize: _appSettings.fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: _appSettings.fontFamily,
          ),
        ),
      ),

      // 📝 حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: _appSettings.fontSize,
          fontFamily: _appSettings.fontFamily,
        ),
      ),

      // 🎛️ أشرطة التمرير
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: _appSettings.fontSize - 2,
          fontFamily: _appSettings.fontFamily,
        ),
      ),

      // 📋 قوائم
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        titleTextStyle: TextStyle(
          fontSize: _appSettings.fontSize,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: _appSettings.fontFamily,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: _appSettings.fontSize - 2,
          color: colorScheme.onSurfaceVariant,
          fontFamily: _appSettings.fontFamily,
        ),
      ),

      // 🎭 رقائق
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        labelStyle: TextStyle(
          fontSize: _appSettings.fontSize - 2,
          fontFamily: _appSettings.fontFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),

      // 🎯 شريط التنقل السفلي
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: _appSettings.fontSize - 4,
          fontWeight: FontWeight.w600,
          fontFamily: _appSettings.fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: _appSettings.fontSize - 4,
          fontFamily: _appSettings.fontFamily,
        ),
      ),

      // 🎪 حوارات
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius * 2),
        ),
        titleTextStyle: TextStyle(
          fontSize: _appSettings.fontSize + 2,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: _appSettings.fontFamily,
        ),
        contentTextStyle: TextStyle(
          fontSize: _appSettings.fontSize,
          color: colorScheme.onSurfaceVariant,
          fontFamily: _appSettings.fontFamily,
        ),
      ),

      // 🎯 شريط التقدم
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // 🎨 أيقونات
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),

      // 🎭 تأثيرات الموجة
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// 📝 بناء نظام النصوص
  TextTheme _buildTextTheme(ColorScheme colorScheme, bool isDark) {
    final baseSize = _appSettings.fontSize;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: baseSize + 16,
        fontWeight: FontWeight.w300,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: baseSize + 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: baseSize + 8,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: baseSize + 6,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: baseSize + 4,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: baseSize + 2,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: baseSize + 2,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: baseSize,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: baseSize - 2,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        fontFamily: _appSettings.fontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: baseSize,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: baseSize - 2,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: baseSize - 4,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
        fontFamily: _appSettings.fontFamily,
      ),
      labelLarge: TextStyle(
        fontSize: baseSize - 2,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        fontFamily: _appSettings.fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: baseSize - 4,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        fontFamily: _appSettings.fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: baseSize - 6,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        fontFamily: _appSettings.fontFamily,
      ),
    );
  }

  /// 🔄 تحديث إعدادات التطبيق
  Future<void> updateAppSettings(AppSettings settings) async {
    _appSettings = settings;
    await _databaseService.saveAppSettings(settings);

    // إعادة بناء الثيمات
    await _buildThemes();
    notifyListeners();
  }

  /// 🌈 تبديل الألوان الديناميكية
  Future<void> toggleDynamicColors() async {
    final newSettings = _appSettings.copyWith(
      useDynamicColors: !_appSettings.useDynamicColors,
    );
    await updateAppSettings(newSettings);
  }

  /// 🌙 تبديل وضع الثيم
  Future<void> toggleThemeMode() async {
    ThemeMode newMode;
    switch (_appSettings.themeMode) {
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        newMode = ThemeMode.light;
        break;
    }

    final newSettings = _appSettings.copyWith(themeMode: newMode);
    await updateAppSettings(newSettings);
  }

  /// 📏 تحديث حجم الخط
  Future<void> updateFontSize(double fontSize) async {
    final newSettings = _appSettings.copyWith(fontSize: fontSize);
    await updateAppSettings(newSettings);
  }

  /// 🔤 تحديث عائلة الخط
  Future<void> updateFontFamily(String fontFamily) async {
    final newSettings = _appSettings.copyWith(fontFamily: fontFamily);
    await updateAppSettings(newSettings);
  }

  /// 🎨 الحصول على لون حسب النوع
  Color getColorByType(String type, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case 'primary':
        return colorScheme.primary;
      case 'secondary':
        return colorScheme.secondary;
      case 'error':
        return colorScheme.error;
      case 'success':
        return const Color(AppConstants.successColorValue);
      case 'warning':
        return const Color(AppConstants.warningColorValue);
      default:
        return colorScheme.primary;
    }
  }
}

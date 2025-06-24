// ⚙️ نماذج بيانات الإعدادات
// يحتوي على جميع النماذج المطلوبة لإدارة إعدادات التطبيق

import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'settings_models.g.dart';

/// 🎛️ إعدادات التطبيق الرئيسية
@JsonSerializable()
@HiveType(typeId: 10)
class AppSettings extends HiveObject {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final ThemeMode themeMode;

  @HiveField(2)
  final bool useDynamicColors;

  @HiveField(3)
  final String fontFamily;

  @HiveField(4)
  final double fontSize;

  @HiveField(5)
  final bool enableAnimations;

  @HiveField(6)
  final bool enableHapticFeedback;

  @HiveField(7)
  final bool enableSounds;

  @HiveField(8)
  final double soundVolume;

  @HiveField(9)
  final bool autoSave;

  @HiveField(10)
  final int autoSaveInterval;

  @HiveField(11)
  final bool enableNotifications;

  @HiveField(12)
  final bool enableBackgroundSync;

  @HiveField(13)
  final String dateFormat;

  @HiveField(14)
  final String timeFormat;

  @HiveField(15)
  final bool showMessageTimestamps;

  @HiveField(16)
  final bool enableMarkdown;

  @HiveField(17)
  final bool enableCodeHighlighting;

  @HiveField(18)
  final double chatBubbleRadius;

  @HiveField(19)
  final bool enableTypingIndicator;

  AppSettings({
    this.language = 'ar',
    this.themeMode = ThemeMode.system,
    this.useDynamicColors = true,
    this.fontFamily = 'Cairo',
    this.fontSize = 16.0,
    this.enableAnimations = true,
    this.enableHapticFeedback = true,
    this.enableSounds = true,
    this.soundVolume = 0.7,
    this.autoSave = true,
    this.autoSaveInterval = 30,
    this.enableNotifications = true,
    this.enableBackgroundSync = false,
    this.dateFormat = 'dd/MM/yyyy',
    this.timeFormat = 'HH:mm',
    this.showMessageTimestamps = true,
    this.enableMarkdown = true,
    this.enableCodeHighlighting = true,
    this.chatBubbleRadius = 12.0,
    this.enableTypingIndicator = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  /// 🔄 نسخ الإعدادات مع تحديثات
  AppSettings copyWith({
    String? language,
    ThemeMode? themeMode,
    bool? useDynamicColors,
    String? fontFamily,
    double? fontSize,
    bool? enableAnimations,
    bool? enableHapticFeedback,
    bool? enableSounds,
    double? soundVolume,
    bool? autoSave,
    int? autoSaveInterval,
    bool? enableNotifications,
    bool? enableBackgroundSync,
    String? dateFormat,
    String? timeFormat,
    bool? showMessageTimestamps,
    bool? enableMarkdown,
    bool? enableCodeHighlighting,
    double? chatBubbleRadius,
    bool? enableTypingIndicator,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableSounds: enableSounds ?? this.enableSounds,
      soundVolume: soundVolume ?? this.soundVolume,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableBackgroundSync: enableBackgroundSync ?? this.enableBackgroundSync,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      showMessageTimestamps:
          showMessageTimestamps ?? this.showMessageTimestamps,
      enableMarkdown: enableMarkdown ?? this.enableMarkdown,
      enableCodeHighlighting:
          enableCodeHighlighting ?? this.enableCodeHighlighting,
      chatBubbleRadius: chatBubbleRadius ?? this.chatBubbleRadius,
      enableTypingIndicator:
          enableTypingIndicator ?? this.enableTypingIndicator,
    );
  }
}

/// 🌐 إعدادات الاتصال
@JsonSerializable()
@HiveType(typeId: 11)
class ConnectionSettings extends HiveObject {
  @HiveField(0)
  final String serverUrl;

  @HiveField(1)
  final int timeout;

  @HiveField(2)
  final int maxRetries;

  @HiveField(3)
  final bool enableSSL;

  @HiveField(4)
  final bool verifySSL;

  @HiveField(5)
  final String? apiKey;

  @HiveField(6)
  final Map<String, String> customHeaders;

  @HiveField(7)
  final bool enableProxy;

  @HiveField(8)
  final String? proxyHost;

  @HiveField(9)
  final int? proxyPort;

  @HiveField(10)
  final String? proxyUsername;

  @HiveField(11)
  final String? proxyPassword;

  @HiveField(12)
  final bool enableCompression;

  @HiveField(13)
  final int streamTimeout;

  @HiveField(14)
  final bool autoReconnect;

  @HiveField(15)
  final int reconnectDelay;

  ConnectionSettings({
    this.serverUrl = 'http://localhost:11434',
    this.timeout = 30000,
    this.maxRetries = 3,
    this.enableSSL = false,
    this.verifySSL = true,
    this.apiKey,
    this.customHeaders = const {},
    this.enableProxy = false,
    this.proxyHost,
    this.proxyPort,
    this.proxyUsername,
    this.proxyPassword,
    this.enableCompression = true,
    this.streamTimeout = 60000,
    this.autoReconnect = true,
    this.reconnectDelay = 5000,
  });

  factory ConnectionSettings.fromJson(Map<String, dynamic> json) =>
      _$ConnectionSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionSettingsToJson(this);

  /// 🔄 نسخ إعدادات الاتصال مع تحديثات
  ConnectionSettings copyWith({
    String? serverUrl,
    int? timeout,
    int? maxRetries,
    bool? enableSSL,
    bool? verifySSL,
    String? apiKey,
    Map<String, String>? customHeaders,
    bool? enableProxy,
    String? proxyHost,
    int? proxyPort,
    String? proxyUsername,
    String? proxyPassword,
    bool? enableCompression,
    int? streamTimeout,
    bool? autoReconnect,
    int? reconnectDelay,
  }) {
    return ConnectionSettings(
      serverUrl: serverUrl ?? this.serverUrl,
      timeout: timeout ?? this.timeout,
      maxRetries: maxRetries ?? this.maxRetries,
      enableSSL: enableSSL ?? this.enableSSL,
      verifySSL: verifySSL ?? this.verifySSL,
      apiKey: apiKey ?? this.apiKey,
      customHeaders: customHeaders ?? this.customHeaders,
      enableProxy: enableProxy ?? this.enableProxy,
      proxyHost: proxyHost ?? this.proxyHost,
      proxyPort: proxyPort ?? this.proxyPort,
      proxyUsername: proxyUsername ?? this.proxyUsername,
      proxyPassword: proxyPassword ?? this.proxyPassword,
      enableCompression: enableCompression ?? this.enableCompression,
      streamTimeout: streamTimeout ?? this.streamTimeout,
      autoReconnect: autoReconnect ?? this.autoReconnect,
      reconnectDelay: reconnectDelay ?? this.reconnectDelay,
    );
  }
}

/// 🔐 إعدادات الأمان والخصوصية
@JsonSerializable()
@HiveType(typeId: 12)
class SecuritySettings extends HiveObject {
  @HiveField(0)
  final bool enableAppLock;

  @HiveField(1)
  final LockType lockType;

  @HiveField(2)
  final String? pinCode;

  @HiveField(3)
  final bool enableBiometric;

  @HiveField(4)
  final int lockTimeout;

  @HiveField(5)
  final bool enableIncognitoMode;

  @HiveField(6)
  final bool encryptLocalData;

  @HiveField(7)
  final bool enableDataCollection;

  @HiveField(8)
  final bool enableCrashReporting;

  @HiveField(9)
  final bool enableAnalytics;

  @HiveField(10)
  final int dataRetentionDays;

  @HiveField(11)
  final bool autoDeleteOldChats;

  @HiveField(12)
  final bool enableScreenshotProtection;

  @HiveField(13)
  final bool enableCopyProtection;

  SecuritySettings({
    this.enableAppLock = false,
    this.lockType = LockType.pin,
    this.pinCode,
    this.enableBiometric = false,
    this.lockTimeout = 300,
    this.enableIncognitoMode = false,
    this.encryptLocalData = true,
    this.enableDataCollection = false,
    this.enableCrashReporting = true,
    this.enableAnalytics = false,
    this.dataRetentionDays = 30,
    this.autoDeleteOldChats = false,
    this.enableScreenshotProtection = false,
    this.enableCopyProtection = false,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SecuritySettingsToJson(this);

  /// 🔄 نسخ إعدادات الأمان مع تحديثات
  SecuritySettings copyWith({
    bool? enableAppLock,
    LockType? lockType,
    String? pinCode,
    bool? enableBiometric,
    int? lockTimeout,
    bool? enableIncognitoMode,
    bool? encryptLocalData,
    bool? enableDataCollection,
    bool? enableCrashReporting,
    bool? enableAnalytics,
    int? dataRetentionDays,
    bool? autoDeleteOldChats,
    bool? enableScreenshotProtection,
    bool? enableCopyProtection,
  }) {
    return SecuritySettings(
      enableAppLock: enableAppLock ?? this.enableAppLock,
      lockType: lockType ?? this.lockType,
      pinCode: pinCode ?? this.pinCode,
      enableBiometric: enableBiometric ?? this.enableBiometric,
      lockTimeout: lockTimeout ?? this.lockTimeout,
      enableIncognitoMode: enableIncognitoMode ?? this.enableIncognitoMode,
      encryptLocalData: encryptLocalData ?? this.encryptLocalData,
      enableDataCollection: enableDataCollection ?? this.enableDataCollection,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      dataRetentionDays: dataRetentionDays ?? this.dataRetentionDays,
      autoDeleteOldChats: autoDeleteOldChats ?? this.autoDeleteOldChats,
      enableScreenshotProtection:
          enableScreenshotProtection ?? this.enableScreenshotProtection,
      enableCopyProtection: enableCopyProtection ?? this.enableCopyProtection,
    );
  }
}

/// 🔒 أنواع القفل
@HiveType(typeId: 13)
enum LockType {
  @HiveField(0)
  pin,
  @HiveField(1)
  password,
  @HiveField(2)
  pattern,
  @HiveField(3)
  biometric,
}

/// 🎵 إعدادات الصوت والوسائط
@JsonSerializable()
@HiveType(typeId: 14)
class AudioSettings extends HiveObject {
  @HiveField(0)
  final bool enableTTS;

  @HiveField(1)
  final bool enableSTT;

  @HiveField(2)
  final String ttsLanguage;

  @HiveField(3)
  final String sttLanguage;

  @HiveField(4)
  final double speechRate;

  @HiveField(5)
  final double speechPitch;

  @HiveField(6)
  final double speechVolume;

  @HiveField(7)
  final String voiceId;

  @HiveField(8)
  final bool autoPlayResponses;

  @HiveField(9)
  final bool enableVoiceCommands;

  @HiveField(10)
  final double recordingQuality;

  @HiveField(11)
  final bool enableNoiseReduction;

  @HiveField(12)
  final bool enableEchoCancellation;

  AudioSettings({
    this.enableTTS = false,
    this.enableSTT = false,
    this.ttsLanguage = 'ar',
    this.sttLanguage = 'ar',
    this.speechRate = 0.5,
    this.speechPitch = 1.0,
    this.speechVolume = 1.0,
    this.voiceId = 'default',
    this.autoPlayResponses = false,
    this.enableVoiceCommands = false,
    this.recordingQuality = 0.8,
    this.enableNoiseReduction = true,
    this.enableEchoCancellation = true,
  });

  factory AudioSettings.fromJson(Map<String, dynamic> json) =>
      _$AudioSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AudioSettingsToJson(this);
}

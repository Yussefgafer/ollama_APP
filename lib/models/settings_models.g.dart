// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 10;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      language: fields[0] as String,
      themeMode: fields[1] as ThemeMode,
      useDynamicColors: fields[2] as bool,
      fontFamily: fields[3] as String,
      fontSize: fields[4] as double,
      enableAnimations: fields[5] as bool,
      enableHapticFeedback: fields[6] as bool,
      enableSounds: fields[7] as bool,
      soundVolume: fields[8] as double,
      autoSave: fields[9] as bool,
      autoSaveInterval: fields[10] as int,
      enableNotifications: fields[11] as bool,
      enableBackgroundSync: fields[12] as bool,
      dateFormat: fields[13] as String,
      timeFormat: fields[14] as String,
      showMessageTimestamps: fields[15] as bool,
      enableMarkdown: fields[16] as bool,
      enableCodeHighlighting: fields[17] as bool,
      chatBubbleRadius: fields[18] as double,
      enableTypingIndicator: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.useDynamicColors)
      ..writeByte(3)
      ..write(obj.fontFamily)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.enableAnimations)
      ..writeByte(6)
      ..write(obj.enableHapticFeedback)
      ..writeByte(7)
      ..write(obj.enableSounds)
      ..writeByte(8)
      ..write(obj.soundVolume)
      ..writeByte(9)
      ..write(obj.autoSave)
      ..writeByte(10)
      ..write(obj.autoSaveInterval)
      ..writeByte(11)
      ..write(obj.enableNotifications)
      ..writeByte(12)
      ..write(obj.enableBackgroundSync)
      ..writeByte(13)
      ..write(obj.dateFormat)
      ..writeByte(14)
      ..write(obj.timeFormat)
      ..writeByte(15)
      ..write(obj.showMessageTimestamps)
      ..writeByte(16)
      ..write(obj.enableMarkdown)
      ..writeByte(17)
      ..write(obj.enableCodeHighlighting)
      ..writeByte(18)
      ..write(obj.chatBubbleRadius)
      ..writeByte(19)
      ..write(obj.enableTypingIndicator);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConnectionSettingsAdapter extends TypeAdapter<ConnectionSettings> {
  @override
  final int typeId = 11;

  @override
  ConnectionSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConnectionSettings(
      serverUrl: fields[0] as String,
      timeout: fields[1] as int,
      maxRetries: fields[2] as int,
      enableSSL: fields[3] as bool,
      verifySSL: fields[4] as bool,
      apiKey: fields[5] as String?,
      customHeaders: (fields[6] as Map).cast<String, String>(),
      enableProxy: fields[7] as bool,
      proxyHost: fields[8] as String?,
      proxyPort: fields[9] as int?,
      proxyUsername: fields[10] as String?,
      proxyPassword: fields[11] as String?,
      enableCompression: fields[12] as bool,
      streamTimeout: fields[13] as int,
      autoReconnect: fields[14] as bool,
      reconnectDelay: fields[15] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ConnectionSettings obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.serverUrl)
      ..writeByte(1)
      ..write(obj.timeout)
      ..writeByte(2)
      ..write(obj.maxRetries)
      ..writeByte(3)
      ..write(obj.enableSSL)
      ..writeByte(4)
      ..write(obj.verifySSL)
      ..writeByte(5)
      ..write(obj.apiKey)
      ..writeByte(6)
      ..write(obj.customHeaders)
      ..writeByte(7)
      ..write(obj.enableProxy)
      ..writeByte(8)
      ..write(obj.proxyHost)
      ..writeByte(9)
      ..write(obj.proxyPort)
      ..writeByte(10)
      ..write(obj.proxyUsername)
      ..writeByte(11)
      ..write(obj.proxyPassword)
      ..writeByte(12)
      ..write(obj.enableCompression)
      ..writeByte(13)
      ..write(obj.streamTimeout)
      ..writeByte(14)
      ..write(obj.autoReconnect)
      ..writeByte(15)
      ..write(obj.reconnectDelay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SecuritySettingsAdapter extends TypeAdapter<SecuritySettings> {
  @override
  final int typeId = 12;

  @override
  SecuritySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecuritySettings(
      enableAppLock: fields[0] as bool,
      lockType: fields[1] as LockType,
      pinCode: fields[2] as String?,
      enableBiometric: fields[3] as bool,
      lockTimeout: fields[4] as int,
      enableIncognitoMode: fields[5] as bool,
      encryptLocalData: fields[6] as bool,
      enableDataCollection: fields[7] as bool,
      enableCrashReporting: fields[8] as bool,
      enableAnalytics: fields[9] as bool,
      dataRetentionDays: fields[10] as int,
      autoDeleteOldChats: fields[11] as bool,
      enableScreenshotProtection: fields[12] as bool,
      enableCopyProtection: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SecuritySettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.enableAppLock)
      ..writeByte(1)
      ..write(obj.lockType)
      ..writeByte(2)
      ..write(obj.pinCode)
      ..writeByte(3)
      ..write(obj.enableBiometric)
      ..writeByte(4)
      ..write(obj.lockTimeout)
      ..writeByte(5)
      ..write(obj.enableIncognitoMode)
      ..writeByte(6)
      ..write(obj.encryptLocalData)
      ..writeByte(7)
      ..write(obj.enableDataCollection)
      ..writeByte(8)
      ..write(obj.enableCrashReporting)
      ..writeByte(9)
      ..write(obj.enableAnalytics)
      ..writeByte(10)
      ..write(obj.dataRetentionDays)
      ..writeByte(11)
      ..write(obj.autoDeleteOldChats)
      ..writeByte(12)
      ..write(obj.enableScreenshotProtection)
      ..writeByte(13)
      ..write(obj.enableCopyProtection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecuritySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AudioSettingsAdapter extends TypeAdapter<AudioSettings> {
  @override
  final int typeId = 14;

  @override
  AudioSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioSettings(
      enableTTS: fields[0] as bool,
      enableSTT: fields[1] as bool,
      ttsLanguage: fields[2] as String,
      sttLanguage: fields[3] as String,
      speechRate: fields[4] as double,
      speechPitch: fields[5] as double,
      speechVolume: fields[6] as double,
      voiceId: fields[7] as String,
      autoPlayResponses: fields[8] as bool,
      enableVoiceCommands: fields[9] as bool,
      recordingQuality: fields[10] as double,
      enableNoiseReduction: fields[11] as bool,
      enableEchoCancellation: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AudioSettings obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.enableTTS)
      ..writeByte(1)
      ..write(obj.enableSTT)
      ..writeByte(2)
      ..write(obj.ttsLanguage)
      ..writeByte(3)
      ..write(obj.sttLanguage)
      ..writeByte(4)
      ..write(obj.speechRate)
      ..writeByte(5)
      ..write(obj.speechPitch)
      ..writeByte(6)
      ..write(obj.speechVolume)
      ..writeByte(7)
      ..write(obj.voiceId)
      ..writeByte(8)
      ..write(obj.autoPlayResponses)
      ..writeByte(9)
      ..write(obj.enableVoiceCommands)
      ..writeByte(10)
      ..write(obj.recordingQuality)
      ..writeByte(11)
      ..write(obj.enableNoiseReduction)
      ..writeByte(12)
      ..write(obj.enableEchoCancellation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LockTypeAdapter extends TypeAdapter<LockType> {
  @override
  final int typeId = 13;

  @override
  LockType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LockType.pin;
      case 1:
        return LockType.password;
      case 2:
        return LockType.pattern;
      case 3:
        return LockType.biometric;
      default:
        return LockType.pin;
    }
  }

  @override
  void write(BinaryWriter writer, LockType obj) {
    switch (obj) {
      case LockType.pin:
        writer.writeByte(0);
        break;
      case LockType.password:
        writer.writeByte(1);
        break;
      case LockType.pattern:
        writer.writeByte(2);
        break;
      case LockType.biometric:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      language: json['language'] as String? ?? 'ar',
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      useDynamicColors: json['useDynamicColors'] as bool? ?? true,
      fontFamily: json['fontFamily'] as String? ?? 'Cairo',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      enableAnimations: json['enableAnimations'] as bool? ?? true,
      enableHapticFeedback: json['enableHapticFeedback'] as bool? ?? true,
      enableSounds: json['enableSounds'] as bool? ?? true,
      soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 0.7,
      autoSave: json['autoSave'] as bool? ?? true,
      autoSaveInterval: (json['autoSaveInterval'] as num?)?.toInt() ?? 30,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableBackgroundSync: json['enableBackgroundSync'] as bool? ?? false,
      dateFormat: json['dateFormat'] as String? ?? 'dd/MM/yyyy',
      timeFormat: json['timeFormat'] as String? ?? 'HH:mm',
      showMessageTimestamps: json['showMessageTimestamps'] as bool? ?? true,
      enableMarkdown: json['enableMarkdown'] as bool? ?? true,
      enableCodeHighlighting: json['enableCodeHighlighting'] as bool? ?? true,
      chatBubbleRadius: (json['chatBubbleRadius'] as num?)?.toDouble() ?? 12.0,
      enableTypingIndicator: json['enableTypingIndicator'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'language': instance.language,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'useDynamicColors': instance.useDynamicColors,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'enableAnimations': instance.enableAnimations,
      'enableHapticFeedback': instance.enableHapticFeedback,
      'enableSounds': instance.enableSounds,
      'soundVolume': instance.soundVolume,
      'autoSave': instance.autoSave,
      'autoSaveInterval': instance.autoSaveInterval,
      'enableNotifications': instance.enableNotifications,
      'enableBackgroundSync': instance.enableBackgroundSync,
      'dateFormat': instance.dateFormat,
      'timeFormat': instance.timeFormat,
      'showMessageTimestamps': instance.showMessageTimestamps,
      'enableMarkdown': instance.enableMarkdown,
      'enableCodeHighlighting': instance.enableCodeHighlighting,
      'chatBubbleRadius': instance.chatBubbleRadius,
      'enableTypingIndicator': instance.enableTypingIndicator,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

ConnectionSettings _$ConnectionSettingsFromJson(Map<String, dynamic> json) =>
    ConnectionSettings(
      serverUrl: json['serverUrl'] as String? ?? 'http://localhost:11434',
      timeout: (json['timeout'] as num?)?.toInt() ?? 30000,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 3,
      enableSSL: json['enableSSL'] as bool? ?? false,
      verifySSL: json['verifySSL'] as bool? ?? true,
      apiKey: json['apiKey'] as String?,
      customHeaders: (json['customHeaders'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      enableProxy: json['enableProxy'] as bool? ?? false,
      proxyHost: json['proxyHost'] as String?,
      proxyPort: (json['proxyPort'] as num?)?.toInt(),
      proxyUsername: json['proxyUsername'] as String?,
      proxyPassword: json['proxyPassword'] as String?,
      enableCompression: json['enableCompression'] as bool? ?? true,
      streamTimeout: (json['streamTimeout'] as num?)?.toInt() ?? 60000,
      autoReconnect: json['autoReconnect'] as bool? ?? true,
      reconnectDelay: (json['reconnectDelay'] as num?)?.toInt() ?? 5000,
    );

Map<String, dynamic> _$ConnectionSettingsToJson(ConnectionSettings instance) =>
    <String, dynamic>{
      'serverUrl': instance.serverUrl,
      'timeout': instance.timeout,
      'maxRetries': instance.maxRetries,
      'enableSSL': instance.enableSSL,
      'verifySSL': instance.verifySSL,
      'apiKey': instance.apiKey,
      'customHeaders': instance.customHeaders,
      'enableProxy': instance.enableProxy,
      'proxyHost': instance.proxyHost,
      'proxyPort': instance.proxyPort,
      'proxyUsername': instance.proxyUsername,
      'proxyPassword': instance.proxyPassword,
      'enableCompression': instance.enableCompression,
      'streamTimeout': instance.streamTimeout,
      'autoReconnect': instance.autoReconnect,
      'reconnectDelay': instance.reconnectDelay,
    };

SecuritySettings _$SecuritySettingsFromJson(Map<String, dynamic> json) =>
    SecuritySettings(
      enableAppLock: json['enableAppLock'] as bool? ?? false,
      lockType: $enumDecodeNullable(_$LockTypeEnumMap, json['lockType']) ??
          LockType.pin,
      pinCode: json['pinCode'] as String?,
      enableBiometric: json['enableBiometric'] as bool? ?? false,
      lockTimeout: (json['lockTimeout'] as num?)?.toInt() ?? 300,
      enableIncognitoMode: json['enableIncognitoMode'] as bool? ?? false,
      encryptLocalData: json['encryptLocalData'] as bool? ?? true,
      enableDataCollection: json['enableDataCollection'] as bool? ?? false,
      enableCrashReporting: json['enableCrashReporting'] as bool? ?? true,
      enableAnalytics: json['enableAnalytics'] as bool? ?? false,
      dataRetentionDays: (json['dataRetentionDays'] as num?)?.toInt() ?? 30,
      autoDeleteOldChats: json['autoDeleteOldChats'] as bool? ?? false,
      enableScreenshotProtection:
          json['enableScreenshotProtection'] as bool? ?? false,
      enableCopyProtection: json['enableCopyProtection'] as bool? ?? false,
    );

Map<String, dynamic> _$SecuritySettingsToJson(SecuritySettings instance) =>
    <String, dynamic>{
      'enableAppLock': instance.enableAppLock,
      'lockType': _$LockTypeEnumMap[instance.lockType]!,
      'pinCode': instance.pinCode,
      'enableBiometric': instance.enableBiometric,
      'lockTimeout': instance.lockTimeout,
      'enableIncognitoMode': instance.enableIncognitoMode,
      'encryptLocalData': instance.encryptLocalData,
      'enableDataCollection': instance.enableDataCollection,
      'enableCrashReporting': instance.enableCrashReporting,
      'enableAnalytics': instance.enableAnalytics,
      'dataRetentionDays': instance.dataRetentionDays,
      'autoDeleteOldChats': instance.autoDeleteOldChats,
      'enableScreenshotProtection': instance.enableScreenshotProtection,
      'enableCopyProtection': instance.enableCopyProtection,
    };

const _$LockTypeEnumMap = {
  LockType.pin: 'pin',
  LockType.password: 'password',
  LockType.pattern: 'pattern',
  LockType.biometric: 'biometric',
};

AudioSettings _$AudioSettingsFromJson(Map<String, dynamic> json) =>
    AudioSettings(
      enableTTS: json['enableTTS'] as bool? ?? false,
      enableSTT: json['enableSTT'] as bool? ?? false,
      ttsLanguage: json['ttsLanguage'] as String? ?? 'ar',
      sttLanguage: json['sttLanguage'] as String? ?? 'ar',
      speechRate: (json['speechRate'] as num?)?.toDouble() ?? 0.5,
      speechPitch: (json['speechPitch'] as num?)?.toDouble() ?? 1.0,
      speechVolume: (json['speechVolume'] as num?)?.toDouble() ?? 1.0,
      voiceId: json['voiceId'] as String? ?? 'default',
      autoPlayResponses: json['autoPlayResponses'] as bool? ?? false,
      enableVoiceCommands: json['enableVoiceCommands'] as bool? ?? false,
      recordingQuality: (json['recordingQuality'] as num?)?.toDouble() ?? 0.8,
      enableNoiseReduction: json['enableNoiseReduction'] as bool? ?? true,
      enableEchoCancellation: json['enableEchoCancellation'] as bool? ?? true,
    );

Map<String, dynamic> _$AudioSettingsToJson(AudioSettings instance) =>
    <String, dynamic>{
      'enableTTS': instance.enableTTS,
      'enableSTT': instance.enableSTT,
      'ttsLanguage': instance.ttsLanguage,
      'sttLanguage': instance.sttLanguage,
      'speechRate': instance.speechRate,
      'speechPitch': instance.speechPitch,
      'speechVolume': instance.speechVolume,
      'voiceId': instance.voiceId,
      'autoPlayResponses': instance.autoPlayResponses,
      'enableVoiceCommands': instance.enableVoiceCommands,
      'recordingQuality': instance.recordingQuality,
      'enableNoiseReduction': instance.enableNoiseReduction,
      'enableEchoCancellation': instance.enableEchoCancellation,
    };

// 🎯 ثوابت التطبيق الأساسية
// يحتوي على جميع الثوابت المستخدمة في التطبيق

class AppConstants {
  // 🏷️ معلومات التطبيق
  static const String appName = 'Ollama Chat';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'تطبيق Flutter احترافي للتفاعل مع Ollama API';

  // 🌐 إعدادات الشبكة
  static const String defaultOllamaUrl = 'http://localhost:11434';
  static const int defaultTimeout = 30000; // 30 ثانية
  static const int maxRetries = 3;
  static const int streamTimeout = 60000; // دقيقة واحدة للـ streaming

  // 📱 إعدادات واجهة المستخدم
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // 💬 إعدادات المحادثة
  static const int maxMessageLength = 4000;
  static const int maxChatHistory = 100;
  static const int messagesPerPage = 20;
  static const double chatBubbleMaxWidth = 0.8;

  // 🎨 إعدادات الثيم
  static const String defaultFontFamily = 'Cairo';
  static const double defaultFontSize = 16.0;
  static const double smallFontSize = 14.0;
  static const double largeFontSize = 18.0;

  // 🔊 إعدادات الصوت
  static const double defaultSpeechRate = 0.5;
  static const double defaultSpeechPitch = 1.0;
  static const double defaultSpeechVolume = 1.0;

  // 📸 إعدادات الصور
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const double imageQuality = 0.8;
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // 💾 إعدادات التخزين
  static const String chatHistoryKey = 'chat_history';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_settings';
  static const String modelsKey = 'ollama_models';

  // 🔐 إعدادات الأمان
  static const int pinLength = 4;
  static const int maxLoginAttempts = 5;
  static const int lockoutDuration = 300; // 5 دقائق

  // 📊 إعدادات الإحصائيات
  static const int statsRetentionDays = 30;
  static const int maxChartDataPoints = 50;

  // 🌍 إعدادات التوطين
  static const List<String> supportedLanguages = ['ar', 'en'];
  static const String defaultLanguage = 'ar';

  // 🎭 أنواع الرسائل
  static const String messageTypeUser = 'user';
  static const String messageTypeAssistant = 'assistant';
  static const String messageTypeSystem = 'system';
  static const String messageTypeError = 'error';

  // 🚀 إعدادات الأداء
  static const int cacheSize = 100 * 1024 * 1024; // 100 MB
  static const int maxConcurrentRequests = 3;
  static const int debounceDelay = 300; // milliseconds

  // 📱 إعدادات الجهاز
  static const double minScreenWidth = 320.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  // 🎯 مفاتيح التنقل
  static const String homeRoute = '/';
  static const String chatRoute = '/chat';
  static const String modelsRoute = '/models';
  static const String settingsRoute = '/settings';
  static const String onboardingRoute = '/onboarding';
  static const String profileRoute = '/profile';
  static const String statisticsRoute = '/statistics';

  // 🔔 إعدادات الإشعارات
  static const String notificationChannelId = 'ollama_chat_channel';
  static const String notificationChannelName = 'Ollama Chat Notifications';
  static const String notificationChannelDescription =
      'إشعارات تطبيق Ollama Chat';

  // 🎨 ألوان النظام
  static const int primaryColorValue = 0xFF6750A4;
  static const int secondaryColorValue = 0xFF625B71;
  static const int errorColorValue = 0xFFBA1A1A;
  static const int successColorValue = 0xFF4CAF50;
  static const int warningColorValue = 0xFFFF9800;

  // 📝 أنماط النصوص
  static const String markdownCodeBlock = '```';
  static const String markdownInlineCode = '`';
  static const String markdownBold = '**';
  static const String markdownItalic = '*';

  // 🔄 حالات التطبيق
  static const String stateLoading = 'loading';
  static const String stateSuccess = 'success';
  static const String stateError = 'error';
  static const String stateEmpty = 'empty';

  // 🎪 أنواع الأنيميشن
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // 📦 إعدادات النسخ الاحتياطي
  static const int backupInterval = 24 * 60 * 60 * 1000; // 24 ساعة
  static const int maxBackupFiles = 7;
  static const String backupFileExtension = '.backup';

  // 🎮 إعدادات الألعاب والنقاط
  static const int pointsPerMessage = 1;
  static const int pointsPerDay = 5;
  static const int pointsPerWeek = 25;
  static const Map<String, int> achievementPoints = {
    'first_chat': 10,
    'daily_user': 20,
    'weekly_user': 50,
    'power_user': 100,
    'explorer': 30,
    'social': 40,
  };

  // 🔍 إعدادات البحث
  static const int searchHistoryLimit = 50;
  static const int minSearchLength = 2;
  static const int searchDebounceMs = 500;

  // 📈 حدود الاستخدام
  static const int maxDailyMessages = 1000;
  static const int maxConcurrentChats = 10;
  static const int maxModelSize = 10 * 1024 * 1024 * 1024; // 10 GB
}

/// 🎨 ثوابت التصميم والألوان
class DesignConstants {
  // 📐 أبعاد الشاشة
  static const double mobileMaxWidth = 480.0;
  static const double tabletMaxWidth = 768.0;
  static const double desktopMaxWidth = 1200.0;

  // 🎭 أشكال الحاويات
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double circularRadius = 50.0;

  // 📏 المسافات
  static const double tinySpace = 4.0;
  static const double smallSpace = 8.0;
  static const double mediumSpace = 16.0;
  static const double largeSpace = 24.0;
  static const double extraLargeSpace = 32.0;

  // 🎯 أحجام الأيقونات
  static const double smallIcon = 16.0;
  static const double mediumIcon = 24.0;
  static const double largeIcon = 32.0;
  static const double extraLargeIcon = 48.0;

  // 📝 أحجام النصوص
  static const double captionSize = 12.0;
  static const double bodySmallSize = 14.0;
  static const double bodySize = 16.0;
  static const double titleSmallSize = 18.0;
  static const double titleSize = 20.0;
  static const double headlineSize = 24.0;
  static const double displaySize = 32.0;
}

/// 🔗 ثوابت API و URLs
class ApiConstants {
  // 🌐 نقاط النهاية الأساسية
  static const String generateEndpoint = '/api/generate';
  static const String chatEndpoint = '/api/chat';
  static const String modelsEndpoint = '/api/tags';
  static const String pullEndpoint = '/api/pull';
  static const String deleteEndpoint = '/api/delete';
  static const String showEndpoint = '/api/show';
  static const String copyEndpoint = '/api/copy';
  static const String embedEndpoint = '/api/embed';

  // 📋 رؤوس HTTP
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ⚙️ معاملات النموذج الافتراضية
  static const Map<String, dynamic> defaultModelParams = {
    'temperature': 0.7,
    'top_p': 0.9,
    'top_k': 40,
    'repeat_penalty': 1.1,
    'num_predict': -1,
    'num_ctx': 2048,
  };
}

/// 🎵 ثوابت الصوت والوسائط
class MediaConstants {
  // 🎤 إعدادات التسجيل
  static const int sampleRate = 16000;
  static const int bitRate = 128000;
  static const String audioFormat = 'wav';
  static const int maxRecordingDuration = 300; // 5 دقائق

  // 🔊 إعدادات التشغيل
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const double minSpeed = 0.5;
  static const double maxSpeed = 2.0;

  // 📱 أنواع الوسائط المدعومة
  static const List<String> supportedAudioFormats = [
    'mp3',
    'wav',
    'aac',
    'm4a',
  ];
  static const List<String> supportedVideoFormats = ['mp4', 'mov', 'avi'];
}

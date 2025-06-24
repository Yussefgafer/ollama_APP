// 💾 خدمة قاعدة البيانات المحلية
// تتعامل مع تخزين واسترجاع البيانات محلياً باستخدام Hive

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chat_models.dart';
import '../models/ollama_models.dart';
import '../models/settings_models.dart';
import '../constants/app_constants.dart';

/// 🗄️ خدمة قاعدة البيانات الرئيسية
class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  DatabaseService._();

  // 📦 صناديق Hive
  late Box<ChatConversation> _conversationsBox;
  late Box<ChatMessage> _messagesBox;
  late Box<OllamaModel> _modelsBox;
  late Box<AppSettings> _settingsBox;
  late Box<ConnectionSettings> _connectionBox;
  late Box<SecuritySettings> _securityBox;
  late Box<AudioSettings> _audioBox;
  late Box<ModelPullStatus> _pullStatusBox;
  late Box<dynamic> _cacheBox;
  late Box<dynamic> _statsBox;

  /// 🚀 تهيئة قاعدة البيانات
  Future<void> initialize({bool enableEncryption = false}) async {
    try {
      // 📁 تحديد مسار التخزين
      await Hive.initFlutter();

      // 🔐 إعداد التشفير إذا كان مفعلاً (معطل حالياً)
      // if (enableEncryption) {
      //   await _setupEncryption();
      // }

      // 📝 تسجيل المحولات
      _registerAdapters();

      // 📦 فتح الصناديق
      await _openBoxes();

      debugPrint('✅ تم تهيئة قاعدة البيانات بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة قاعدة البيانات: $e');
      rethrow;
    }
  }

  /// 📝 تسجيل محولات Hive
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OllamaModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ModelPullStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ModelParametersAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ChatConversationAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(MessageRoleAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(MessageStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(MessageAttachmentAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(AttachmentTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ConnectionSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(SecuritySettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(LockTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(AudioSettingsAdapter());
    }
  }

  /// 📦 فتح جميع الصناديق
  Future<void> _openBoxes() async {
    _conversationsBox = await Hive.openBox<ChatConversation>('conversations');
    _messagesBox = await Hive.openBox<ChatMessage>('messages');
    _modelsBox = await Hive.openBox<OllamaModel>('models');
    _settingsBox = await Hive.openBox<AppSettings>('settings');
    _connectionBox = await Hive.openBox<ConnectionSettings>('connection');
    _securityBox = await Hive.openBox<SecuritySettings>('security');
    _audioBox = await Hive.openBox<AudioSettings>('audio');
    _pullStatusBox = await Hive.openBox<ModelPullStatus>('pull_status');
    _cacheBox = await Hive.openBox('cache');
    _statsBox = await Hive.openBox('stats');
  }

  // 💬 عمليات المحادثات

  /// 💾 حفظ محادثة
  Future<void> saveConversation(ChatConversation conversation) async {
    await _conversationsBox.put(conversation.id, conversation);
  }

  /// 📋 جلب جميع المحادثات
  List<ChatConversation> getAllConversations() {
    return _conversationsBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// 🔍 البحث في المحادثات
  List<ChatConversation> searchConversations(String query) {
    return _conversationsBox.values
        .where(
          (conv) =>
              conv.title.toLowerCase().contains(query.toLowerCase()) ||
              conv.messages.any(
                (msg) =>
                    msg.content.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

  /// 🗑️ حذف محادثة
  Future<void> deleteConversation(String conversationId) async {
    await _conversationsBox.delete(conversationId);

    // حذف الرسائل المرتبطة
    final messagesToDelete = _messagesBox.values
        .where((msg) => msg.metadata?['conversationId'] == conversationId)
        .map((msg) => msg.key)
        .toList();

    for (final key in messagesToDelete) {
      await _messagesBox.delete(key);
    }
  }

  /// 📊 إحصائيات المحادثات
  Map<String, dynamic> getConversationStats() {
    final conversations = _conversationsBox.values;
    final totalMessages = conversations.fold<int>(
      0,
      (sum, conv) => sum + conv.messages.length,
    );

    return {
      'totalConversations': conversations.length,
      'totalMessages': totalMessages,
      'averageMessagesPerConversation': conversations.isNotEmpty
          ? totalMessages / conversations.length
          : 0,
      'pinnedConversations': conversations.where((c) => c.isPinned).length,
      'archivedConversations': conversations.where((c) => c.isArchived).length,
    };
  }

  // 🤖 عمليات النماذج

  /// 💾 حفظ نموذج
  Future<void> saveModel(OllamaModel model) async {
    await _modelsBox.put(model.name, model);
  }

  /// 📋 جلب جميع النماذج
  List<OllamaModel> getAllModels() {
    return _modelsBox.values.toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
  }

  /// ⭐ جلب النماذج المفضلة
  List<OllamaModel> getFavoriteModels() {
    return _modelsBox.values.where((model) => model.isFavorite).toList();
  }

  /// 🔄 تحديث حالة تحميل النموذج
  Future<void> updatePullStatus(ModelPullStatus status) async {
    await _pullStatusBox.put(status.modelName, status);
  }

  /// 📊 جلب حالة التحميل
  ModelPullStatus? getPullStatus(String modelName) {
    return _pullStatusBox.get(modelName);
  }

  // ⚙️ عمليات الإعدادات

  /// 💾 حفظ إعدادات التطبيق
  Future<void> saveAppSettings(AppSettings settings) async {
    await _settingsBox.put('app', settings);
  }

  /// 📋 جلب إعدادات التطبيق
  AppSettings getAppSettings() {
    return _settingsBox.get('app') ?? AppSettings();
  }

  /// 💾 حفظ إعدادات الاتصال
  Future<void> saveConnectionSettings(ConnectionSettings settings) async {
    await _connectionBox.put('connection', settings);
  }

  /// 📋 جلب إعدادات الاتصال
  ConnectionSettings getConnectionSettings() {
    return _connectionBox.get('connection') ?? ConnectionSettings();
  }

  /// 💾 حفظ إعدادات الأمان
  Future<void> saveSecuritySettings(SecuritySettings settings) async {
    await _securityBox.put('security', settings);
  }

  /// 📋 جلب إعدادات الأمان
  SecuritySettings getSecuritySettings() {
    return _securityBox.get('security') ?? SecuritySettings();
  }

  /// 💾 حفظ إعدادات الصوت
  Future<void> saveAudioSettings(AudioSettings settings) async {
    await _audioBox.put('audio', settings);
  }

  /// 📋 جلب إعدادات الصوت
  AudioSettings getAudioSettings() {
    return _audioBox.get('audio') ?? AudioSettings();
  }

  // 🗂️ عمليات التخزين المؤقت

  /// 💾 حفظ في التخزين المؤقت
  Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await _cacheBox.put(key, cacheItem);
  }

  /// 📋 جلب من التخزين المؤقت
  T? getCachedData<T>(String key) {
    final cacheItem = _cacheBox.get(key);
    if (cacheItem == null) return null;

    final timestamp = cacheItem['timestamp'] as int;
    final expiry = cacheItem['expiry'] as int?;

    if (expiry != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp > expiry) {
        _cacheBox.delete(key);
        return null;
      }
    }

    return cacheItem['data'] as T?;
  }

  /// 🧹 تنظيف التخزين المؤقت المنتهي الصلاحية
  Future<void> cleanExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keysToDelete = <String>[];

    for (final key in _cacheBox.keys) {
      final cacheItem = _cacheBox.get(key);
      if (cacheItem != null && cacheItem['expiry'] != null) {
        final timestamp = cacheItem['timestamp'] as int;
        final expiry = cacheItem['expiry'] as int;

        if (now - timestamp > expiry) {
          keysToDelete.add(key.toString());
        }
      }
    }

    for (final key in keysToDelete) {
      await _cacheBox.delete(key);
    }
  }

  // 📊 عمليات الإحصائيات

  /// 💾 حفظ إحصائية
  Future<void> saveStats(String key, Map<String, dynamic> stats) async {
    await _statsBox.put(key, stats);
  }

  /// 📋 جلب إحصائية
  Map<String, dynamic>? getStats(String key) {
    return _statsBox.get(key)?.cast<String, dynamic>();
  }

  // 🔄 عمليات النسخ الاحتياطي والاستعادة

  /// 💾 إنشاء نسخة احتياطية
  Future<File> createBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupFile = File('${backupDir.path}/backup_$timestamp.json');

    final backupData = {
      'conversations': _conversationsBox.values.map((c) => c.toJson()).toList(),
      'models': _modelsBox.values.map((m) => m.toJson()).toList(),
      'settings': {
        'app': getAppSettings().toJson(),
        'connection': getConnectionSettings().toJson(),
        'security': getSecuritySettings().toJson(),
        'audio': getAudioSettings().toJson(),
      },
      'timestamp': timestamp,
      'version': AppConstants.appVersion,
    };

    await backupFile.writeAsString(jsonEncode(backupData));
    return backupFile;
  }

  /// 🔄 استعادة من نسخة احتياطية
  Future<void> restoreFromBackup(File backupFile) async {
    try {
      final content = await backupFile.readAsString();
      final backupData = jsonDecode(content) as Map<String, dynamic>;

      // استعادة المحادثات
      if (backupData['conversations'] != null) {
        await _conversationsBox.clear();
        for (final convData in backupData['conversations']) {
          final conversation = ChatConversation.fromJson(convData);
          await saveConversation(conversation);
        }
      }

      // استعادة النماذج
      if (backupData['models'] != null) {
        await _modelsBox.clear();
        for (final modelData in backupData['models']) {
          final model = OllamaModel.fromJson(modelData);
          await saveModel(model);
        }
      }

      // استعادة الإعدادات
      if (backupData['settings'] != null) {
        final settings = backupData['settings'] as Map<String, dynamic>;

        if (settings['app'] != null) {
          await saveAppSettings(AppSettings.fromJson(settings['app']));
        }
        if (settings['connection'] != null) {
          await saveConnectionSettings(
            ConnectionSettings.fromJson(settings['connection']),
          );
        }
        if (settings['security'] != null) {
          await saveSecuritySettings(
            SecuritySettings.fromJson(settings['security']),
          );
        }
        if (settings['audio'] != null) {
          await saveAudioSettings(AudioSettings.fromJson(settings['audio']));
        }
      }

      debugPrint('✅ تم استعادة النسخة الاحتياطية بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في استعادة النسخة الاحتياطية: $e');
      rethrow;
    }
  }

  /// 🧹 تنظيف قاعدة البيانات
  Future<void> cleanup() async {
    await cleanExpiredCache();

    // حذف المحادثات القديمة إذا كان مفعلاً
    final securitySettings = getSecuritySettings();
    if (securitySettings.autoDeleteOldChats) {
      final cutoffDate = DateTime.now().subtract(
        Duration(days: securitySettings.dataRetentionDays),
      );

      final oldConversations = _conversationsBox.values
          .where((conv) => conv.updatedAt.isBefore(cutoffDate))
          .toList();

      for (final conv in oldConversations) {
        await deleteConversation(conv.id);
      }
    }
  }

  /// 🗑️ حذف جميع البيانات
  Future<void> clearAllData() async {
    await _conversationsBox.clear();
    await _messagesBox.clear();
    await _modelsBox.clear();
    await _pullStatusBox.clear();
    await _cacheBox.clear();
    await _statsBox.clear();
  }

  /// 🔒 إغلاق قاعدة البيانات
  Future<void> close() async {
    await Hive.close();
  }
}

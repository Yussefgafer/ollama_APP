// 🤖 موفر Ollama - إدارة حالة التطبيق الرئيسية
// يدير جميع العمليات المتعلقة بـ Ollama API والمحادثات

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/ollama_models.dart';
import '../models/chat_models.dart';
import '../models/settings_models.dart';
import '../services/ollama_service.dart';
import '../services/database_service.dart';

/// 🎯 حالة التطبيق
enum AppState { initial, loading, loaded, error, offline }

/// 🤖 موفر Ollama الرئيسي
class OllamaProvider extends ChangeNotifier {
  // 🏗️ الخدمات
  late OllamaService _ollamaService;
  final DatabaseService _databaseService = DatabaseService.instance;

  // 📊 حالة التطبيق
  AppState _appState = AppState.initial;
  String? _errorMessage;
  bool _isConnected = false;

  // 🤖 النماذج
  List<OllamaModel> _models = [];
  OllamaModel? _selectedModel;
  final Map<String, ModelPullStatus> _pullStatuses = {};

  // 💬 المحادثات
  List<ChatConversation> _conversations = [];
  ChatConversation? _currentConversation;
  final Map<String, StreamSubscription> _messageStreams = {};

  // ⚙️ الإعدادات
  ConnectionSettings _connectionSettings = ConnectionSettings();
  ModelParameters _modelParameters = ModelParameters();

  // 📊 الإحصائيات
  Map<String, dynamic> _stats = {};

  // Getters
  AppState get appState => _appState;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  List<OllamaModel> get models => List.unmodifiable(_models);
  OllamaModel? get selectedModel => _selectedModel;
  List<ChatConversation> get conversations => List.unmodifiable(_conversations);
  ChatConversation? get currentConversation => _currentConversation;
  ConnectionSettings get connectionSettings => _connectionSettings;
  ModelParameters get modelParameters => _modelParameters;
  Map<String, dynamic> get stats => Map.unmodifiable(_stats);

  /// 🚀 تهيئة الموفر
  Future<void> initialize() async {
    try {
      _setState(AppState.loading);

      // تحميل الإعدادات من قاعدة البيانات
      await _loadSettings();

      // تهيئة خدمة Ollama
      _ollamaService = OllamaService(
        baseUrl: _connectionSettings.serverUrl,
        timeout: _connectionSettings.timeout,
        maxRetries: _connectionSettings.maxRetries,
      );

      // تحميل البيانات المحفوظة
      await _loadSavedData();

      // فحص الاتصال
      await _checkConnection();

      _setState(AppState.loaded);
    } catch (e) {
      _setError('فشل في تهيئة التطبيق: $e');
    }
  }

  /// 📥 تحميل الإعدادات
  Future<void> _loadSettings() async {
    _connectionSettings = _databaseService.getConnectionSettings();
    _modelParameters =
        ModelParameters(); // يمكن تحميلها من قاعدة البيانات لاحقاً
  }

  /// 📥 تحميل البيانات المحفوظة
  Future<void> _loadSavedData() async {
    _models = _databaseService.getAllModels();
    _conversations = _databaseService.getAllConversations();

    // تحديد النموذج المحدد
    if (_models.isNotEmpty && _selectedModel == null) {
      _selectedModel = _models.first;
    }
  }

  /// 🔍 فحص الاتصال
  Future<void> _checkConnection() async {
    try {
      _isConnected = await _ollamaService.checkServerHealth();
      if (_isConnected) {
        await refreshModels();
      }
    } catch (e) {
      _isConnected = false;
      debugPrint('خطأ في فحص الاتصال: $e');
    }
  }

  /// 🔄 تحديث قائمة النماذج
  Future<void> refreshModels() async {
    try {
      if (!_isConnected) {
        throw Exception('لا يوجد اتصال بالخادم');
      }

      final serverModels = await _ollamaService.getModels();

      // دمج النماذج من الخادم مع البيانات المحلية
      final updatedModels = <OllamaModel>[];

      for (final serverModel in serverModels) {
        final localModel = _models.firstWhere(
          (m) => m.name == serverModel.name,
          orElse: () => serverModel,
        );

        // تحديث معلومات النموذج مع الاحتفاظ بالبيانات المحلية
        final updatedModel = serverModel.copyWith(
          isFavorite: localModel.isFavorite,
          usageCount: localModel.usageCount,
          lastUsed: localModel.lastUsed,
          isDownloaded: true,
        );

        updatedModels.add(updatedModel);
        await _databaseService.saveModel(updatedModel);
      }

      _models = updatedModels;
      notifyListeners();
    } catch (e) {
      _setError('فشل في تحديث النماذج: $e');
    }
  }

  /// 📥 تحميل نموذج جديد
  Future<void> pullModel(String modelName) async {
    try {
      if (!_isConnected) {
        throw Exception('لا يوجد اتصال بالخادم');
      }

      await for (final status in _ollamaService.pullModel(modelName)) {
        _pullStatuses[modelName] = status;
        await _databaseService.updatePullStatus(status);
        notifyListeners();

        if (status.isCompleted) {
          await refreshModels();
          break;
        }
      }
    } catch (e) {
      _setError('فشل في تحميل النموذج: $e');
    }
  }

  /// 🗑️ حذف نموذج
  Future<void> deleteModel(String modelName) async {
    try {
      if (!_isConnected) {
        throw Exception('لا يوجد اتصال بالخادم');
      }

      final success = await _ollamaService.deleteModel(modelName);
      if (success) {
        _models.removeWhere((model) => model.name == modelName);
        await refreshModels();
        notifyListeners();
      }
    } catch (e) {
      _setError('فشل في حذف النموذج: $e');
    }
  }

  /// 🎯 تحديد النموذج النشط
  void selectModel(OllamaModel model) {
    _selectedModel = model;
    notifyListeners();
  }

  /// ⭐ تبديل حالة المفضلة للنموذج
  Future<void> toggleModelFavorite(OllamaModel model) async {
    final updatedModel = model.copyWith(isFavorite: !model.isFavorite);

    final index = _models.indexWhere((m) => m.name == model.name);
    if (index != -1) {
      _models[index] = updatedModel;
      await _databaseService.saveModel(updatedModel);
      notifyListeners();
    }
  }

  /// 💬 إنشاء محادثة جديدة
  Future<ChatConversation> createNewConversation({
    String? title,
    String? modelName,
  }) async {
    final conversation = ChatConversation(
      title: title ?? 'محادثة جديدة',
      modelName: modelName ?? _selectedModel?.name ?? '',
    );

    _conversations.insert(0, conversation);
    _currentConversation = conversation;

    await _databaseService.saveConversation(conversation);
    notifyListeners();

    return conversation;
  }

  /// 🎯 تحديد المحادثة النشطة
  void selectConversation(ChatConversation conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }

  /// 💬 إرسال رسالة
  Future<void> sendMessage(
    String content, {
    List<MessageAttachment>? attachments,
  }) async {
    if (_currentConversation == null || _selectedModel == null) {
      throw Exception('لا توجد محادثة أو نموذج محدد');
    }

    try {
      // إنشاء رسالة المستخدم
      final userMessage = ChatMessage(
        content: content,
        role: MessageRole.user,
        attachments: attachments,
      );

      // إضافة رسالة المستخدم للمحادثة
      final updatedMessages = List<ChatMessage>.from(
        _currentConversation!.messages,
      )..add(userMessage);

      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      await _databaseService.saveConversation(_currentConversation!);
      notifyListeners();

      // إنشاء رسالة الرد
      final assistantMessage = ChatMessage(
        content: '',
        role: MessageRole.assistant,
        status: MessageStatus.streaming,
      );

      final allMessages = List<ChatMessage>.from(updatedMessages)
        ..add(assistantMessage);
      _currentConversation = _currentConversation!.copyWith(
        messages: allMessages,
      );
      notifyListeners();

      // إرسال الرسالة للخادم
      String fullResponse = '';
      final startTime = DateTime.now();

      await for (final chunk in _ollamaService.sendMessage(
        model: _selectedModel!.name,
        messages: updatedMessages,
        parameters: _modelParameters,
      )) {
        fullResponse += chunk;

        // تحديث رسالة الرد
        final updatedAssistantMessage = assistantMessage.copyWith(
          content: fullResponse,
          status: MessageStatus.streaming,
        );

        final messageIndex = allMessages.length - 1;
        allMessages[messageIndex] = updatedAssistantMessage;

        _currentConversation = _currentConversation!.copyWith(
          messages: allMessages,
        );
        notifyListeners();
      }

      // إنهاء الرسالة
      final responseTime = DateTime.now()
          .difference(startTime)
          .inMilliseconds
          .toDouble();
      final finalAssistantMessage = assistantMessage.copyWith(
        content: fullResponse,
        status: MessageStatus.sent,
        responseTime: responseTime,
        tokenCount: fullResponse.split(' ').length,
      );

      allMessages[allMessages.length - 1] = finalAssistantMessage;
      _currentConversation = _currentConversation!.copyWith(
        messages: allMessages,
        updatedAt: DateTime.now(),
      );

      // تحديث إحصائيات النموذج
      await _updateModelUsage(_selectedModel!);

      await _databaseService.saveConversation(_currentConversation!);
      notifyListeners();
    } catch (e) {
      // تحديث حالة الرسالة إلى فشل
      if (_currentConversation != null &&
          _currentConversation!.messages.isNotEmpty) {
        final messages = List<ChatMessage>.from(_currentConversation!.messages);
        final lastMessage = messages.last;

        if (lastMessage.role == MessageRole.assistant) {
          messages[messages.length - 1] = lastMessage.copyWith(
            status: MessageStatus.failed,
            content: lastMessage.content.isEmpty
                ? 'فشل في الإرسال'
                : lastMessage.content,
          );

          _currentConversation = _currentConversation!.copyWith(
            messages: messages,
          );
          await _databaseService.saveConversation(_currentConversation!);
          notifyListeners();
        }
      }

      _setError('فشل في إرسال الرسالة: $e');
    }
  }

  /// 📊 تحديث إحصائيات استخدام النموذج
  Future<void> _updateModelUsage(OllamaModel model) async {
    final updatedModel = model.copyWith(
      usageCount: model.usageCount + 1,
      lastUsed: DateTime.now(),
    );

    final index = _models.indexWhere((m) => m.name == model.name);
    if (index != -1) {
      _models[index] = updatedModel;
      await _databaseService.saveModel(updatedModel);
    }
  }

  /// 🗑️ حذف محادثة
  Future<void> deleteConversation(String conversationId) async {
    _conversations.removeWhere((conv) => conv.id == conversationId);

    if (_currentConversation?.id == conversationId) {
      _currentConversation = null;
    }

    await _databaseService.deleteConversation(conversationId);
    notifyListeners();
  }

  /// 📌 تثبيت/إلغاء تثبيت محادثة
  Future<void> toggleConversationPin(ChatConversation conversation) async {
    final updatedConversation = conversation.copyWith(
      isPinned: !conversation.isPinned,
    );

    final index = _conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      _conversations[index] = updatedConversation;

      if (_currentConversation?.id == conversation.id) {
        _currentConversation = updatedConversation;
      }

      await _databaseService.saveConversation(updatedConversation);
      notifyListeners();
    }
  }

  /// 🔍 البحث في المحادثات
  List<ChatConversation> searchConversations(String query) {
    if (query.isEmpty) return _conversations;
    return _databaseService.searchConversations(query);
  }

  /// ⚙️ تحديث إعدادات الاتصال
  Future<void> updateConnectionSettings(ConnectionSettings settings) async {
    _connectionSettings = settings;
    await _databaseService.saveConnectionSettings(settings);

    // إعادة تهيئة خدمة Ollama
    _ollamaService = OllamaService(
      baseUrl: settings.serverUrl,
      timeout: settings.timeout,
      maxRetries: settings.maxRetries,
    );

    await _checkConnection();
    notifyListeners();
  }

  /// ⚙️ تحديث معاملات النموذج
  void updateModelParameters(ModelParameters parameters) {
    _modelParameters = parameters;
    notifyListeners();
  }

  /// 📊 جلب الإحصائيات
  Future<void> loadStats() async {
    _stats = {
      'conversations': _databaseService.getConversationStats(),
      'service': _ollamaService.getServiceStats(),
      'models': {
        'total': _models.length,
        'favorites': _models.where((m) => m.isFavorite).length,
        'mostUsed': _models.isNotEmpty
            ? _models.reduce((a, b) => a.usageCount > b.usageCount ? a : b).name
            : null,
      },
    };
    notifyListeners();
  }

  /// ❌ تعيين حالة الخطأ
  void _setError(String message) {
    _errorMessage = message;
    _setState(AppState.error);
    debugPrint('خطأ: $message');
  }

  /// 🔄 تعيين حالة التطبيق
  void _setState(AppState state) {
    _appState = state;
    notifyListeners();
  }

  /// 🧹 تنظيف الموارد
  @override
  void dispose() {
    // إلغاء جميع الاشتراكات
    for (final subscription in _messageStreams.values) {
      subscription.cancel();
    }
    _messageStreams.clear();

    // تنظيف الخدمات
    _ollamaService.dispose();

    super.dispose();
  }
}

// 🤖 خدمة Ollama API
// تتعامل مع جميع استدعاءات API الخاصة بـ Ollama

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/ollama_models.dart';
import '../models/chat_models.dart';
import '../constants/app_constants.dart';

/// 🌐 خدمة Ollama الرئيسية
class OllamaService {
  late Dio _dio;
  final String baseUrl;
  final int timeout;
  final int maxRetries;

  // 📊 إحصائيات الخدمة
  int _requestCount = 0;
  int _errorCount = 0;
  final List<Duration> _responseTimes = [];

  // 📡 حالة الاتصال
  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  OllamaService({
    this.baseUrl = AppConstants.defaultOllamaUrl,
    this.timeout = AppConstants.defaultTimeout,
    this.maxRetries = AppConstants.maxRetries,
  }) {
    _initializeDio();
    _setupConnectivityListener();
  }

  /// 🔧 تهيئة Dio
  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: timeout),
        receiveTimeout: Duration(milliseconds: timeout),
        sendTimeout: Duration(milliseconds: timeout),
        headers: ApiConstants.defaultHeaders,
      ),
    );

    // 📝 إضافة Interceptors
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint('🌐 API: $obj'),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _requestCount++;
          options.extra['start_time'] = DateTime.now();
          handler.next(options);
        },
        onResponse: (response, handler) {
          final startTime =
              response.requestOptions.extra['start_time'] as DateTime;
          final responseTime = DateTime.now().difference(startTime);
          _responseTimes.add(responseTime);
          handler.next(response);
        },
        onError: (error, handler) {
          _errorCount++;
          handler.next(error);
        },
      ),
    );
  }

  /// 📡 إعداد مراقب الاتصال
  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _isConnected =
          results.isNotEmpty &&
          !results.every((result) => result == ConnectivityResult.none);
    });
  }

  /// 🔍 فحص حالة الخادم
  Future<bool> checkServerHealth() async {
    try {
      final response = await _dio.get('/api/tags');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 📋 جلب قائمة النماذج المتاحة
  Future<List<OllamaModel>> getModels() async {
    try {
      final response = await _retryRequest(
        () => _dio.get(ApiConstants.modelsEndpoint),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final models = (data['models'] as List)
            .map((model) => OllamaModel.fromJson(model))
            .toList();

        return models;
      } else {
        throw OllamaException('فشل في جلب النماذج: ${response.statusCode}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 🔄 تحميل نموذج جديد
  Stream<ModelPullStatus> pullModel(String modelName) async* {
    try {
      final response = await _dio.post(
        ApiConstants.pullEndpoint,
        data: {'name': modelName},
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration(milliseconds: AppConstants.streamTimeout),
        ),
      );

      await for (final chunk in response.data.stream) {
        final lines = utf8.decode(chunk).split('\n');

        for (final line in lines) {
          if (line.trim().isNotEmpty) {
            try {
              final data = jsonDecode(line);
              yield ModelPullStatus.fromJson({
                'modelName': modelName,
                'status': data['status'] ?? 'downloading',
                'total': data['total'],
                'completed': data['completed'],
                'digest': data['digest'],
                'timestamp': DateTime.now().toIso8601String(),
              });
            } catch (e) {
              // تجاهل الأسطر غير الصالحة
            }
          }
        }
      }
    } catch (e) {
      yield ModelPullStatus(
        modelName: modelName,
        status: 'error',
        timestamp: DateTime.now(),
      );
      throw _handleError(e);
    }
  }

  /// 🗑️ حذف نموذج
  Future<bool> deleteModel(String modelName) async {
    try {
      final response = await _retryRequest(
        () =>
            _dio.delete(ApiConstants.deleteEndpoint, data: {'name': modelName}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 💬 إرسال رسالة للمحادثة
  Stream<String> sendMessage({
    required String model,
    required List<ChatMessage> messages,
    ModelParameters? parameters,
  }) async* {
    try {
      final requestData = {
        'model': model,
        'messages': messages
            .map((msg) => {'role': msg.role.name, 'content': msg.content})
            .toList(),
        'stream': true,
        'options': parameters?.toApiMap() ?? ApiConstants.defaultModelParams,
      };

      final response = await _dio.post(
        ApiConstants.chatEndpoint,
        data: requestData,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration(milliseconds: AppConstants.streamTimeout),
        ),
      );

      await for (final chunk in response.data.stream) {
        final lines = utf8.decode(chunk).split('\n');

        for (final line in lines) {
          if (line.trim().isNotEmpty) {
            try {
              final data = jsonDecode(line);

              if (data['message'] != null &&
                  data['message']['content'] != null) {
                final content = data['message']['content'] as String;
                yield content;
              }

              if (data['done'] == true) {
                return;
              }
            } catch (e) {
              // تجاهل الأسطر غير الصالحة
            }
          }
        }
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 🔄 إعادة المحاولة مع التأخير التدريجي
  Future<Response> _retryRequest(Future<Response> Function() request) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await request();
      } catch (e) {
        attempts++;

        if (attempts >= maxRetries) {
          rethrow;
        }

        // تأخير تدريجي
        final delay = Duration(milliseconds: 1000 * attempts);
        await Future.delayed(delay);
      }
    }

    throw OllamaException('فشل في الطلب بعد $maxRetries محاولات');
  }

  /// ❌ معالجة الأخطاء
  OllamaException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return OllamaException('انتهت مهلة الاتصال');

        case DioExceptionType.connectionError:
          return OllamaException('خطأ في الاتصال بالخادم');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['error'] ?? 'خطأ في الخادم';
          return OllamaException('خطأ HTTP $statusCode: $message');

        case DioExceptionType.cancel:
          return OllamaException('تم إلغاء الطلب');

        default:
          return OllamaException('خطأ غير معروف: ${error.message}');
      }
    }

    return OllamaException('خطأ غير متوقع: $error');
  }

  /// 📊 إحصائيات الخدمة
  Map<String, dynamic> getServiceStats() {
    return {
      'requestCount': _requestCount,
      'errorCount': _errorCount,
      'successRate': _requestCount > 0
          ? (_requestCount - _errorCount) / _requestCount
          : 0.0,
      'averageResponseTime': _responseTimes.isNotEmpty
          ? _responseTimes
                    .map((d) => d.inMilliseconds)
                    .reduce((a, b) => a + b) /
                _responseTimes.length
          : 0.0,
      'isConnected': _isConnected,
    };
  }

  /// 🧹 تنظيف الموارد
  void dispose() {
    _connectivitySubscription?.cancel();
    _dio.close();
  }
}

/// ❌ استثناء Ollama
class OllamaException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  OllamaException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'OllamaException: $message';
}

/// 🔌 حالة الاتصال
enum ConnectionStatus { connected, disconnected, connecting, error }

/// 📊 معلومات الأداء
class PerformanceInfo {
  final int requestCount;
  final int errorCount;
  final double averageResponseTime;
  final double successRate;
  final DateTime lastRequest;

  PerformanceInfo({
    required this.requestCount,
    required this.errorCount,
    required this.averageResponseTime,
    required this.successRate,
    required this.lastRequest,
  });

  Map<String, dynamic> toJson() => {
    'requestCount': requestCount,
    'errorCount': errorCount,
    'averageResponseTime': averageResponseTime,
    'successRate': successRate,
    'lastRequest': lastRequest.toIso8601String(),
  };
}

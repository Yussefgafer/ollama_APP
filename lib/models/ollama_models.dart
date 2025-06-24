// 🤖 نماذج بيانات Ollama API
// يحتوي على جميع النماذج المطلوبة للتفاعل مع Ollama API

import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'ollama_models.g.dart';

/// 🎯 نموذج معلومات النموذج الأساسي
@JsonSerializable()
@HiveType(typeId: 0)
class OllamaModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? tag;

  @HiveField(2)
  final int? size;

  @HiveField(3)
  final String? digest;

  @HiveField(4)
  final DateTime? modifiedAt;

  @HiveField(5)
  final Map<String, dynamic>? details;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final List<String>? capabilities;

  @HiveField(8)
  final bool isDownloaded;

  @HiveField(9)
  final bool isFavorite;

  @HiveField(10)
  final int usageCount;

  @HiveField(11)
  final DateTime? lastUsed;

  OllamaModel({
    required this.name,
    this.tag,
    this.size,
    this.digest,
    this.modifiedAt,
    this.details,
    this.description,
    this.capabilities,
    this.isDownloaded = false,
    this.isFavorite = false,
    this.usageCount = 0,
    this.lastUsed,
  });

  factory OllamaModel.fromJson(Map<String, dynamic> json) =>
      _$OllamaModelFromJson(json);
  Map<String, dynamic> toJson() => _$OllamaModelToJson(this);

  /// 📊 حجم النموذج بصيغة قابلة للقراءة
  String get formattedSize {
    if (size == null) return 'غير معروف';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double bytes = size!.toDouble();
    int unitIndex = 0;

    while (bytes >= 1024 && unitIndex < units.length - 1) {
      bytes /= 1024;
      unitIndex++;
    }

    return '${bytes.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  /// 🏷️ اسم النموذج المختصر
  String get displayName {
    return name.split(':').first;
  }

  /// 🎨 لون النموذج حسب النوع
  int get colorCode {
    final hash = name.hashCode;
    return 0xFF000000 + (hash & 0xFFFFFF);
  }

  /// 📈 معدل الاستخدام
  double get usageRate {
    if (usageCount == 0) return 0.0;
    final daysSinceLastUse = lastUsed != null
        ? DateTime.now().difference(lastUsed!).inDays
        : 30;
    return usageCount / (daysSinceLastUse + 1);
  }

  /// 🔄 نسخ النموذج مع تحديثات
  OllamaModel copyWith({
    String? name,
    String? tag,
    int? size,
    String? digest,
    DateTime? modifiedAt,
    Map<String, dynamic>? details,
    String? description,
    List<String>? capabilities,
    bool? isDownloaded,
    bool? isFavorite,
    int? usageCount,
    DateTime? lastUsed,
  }) {
    return OllamaModel(
      name: name ?? this.name,
      tag: tag ?? this.tag,
      size: size ?? this.size,
      digest: digest ?? this.digest,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      details: details ?? this.details,
      description: description ?? this.description,
      capabilities: capabilities ?? this.capabilities,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isFavorite: isFavorite ?? this.isFavorite,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

/// 📋 قائمة النماذج المتاحة
@JsonSerializable()
class OllamaModelsResponse {
  final List<OllamaModel> models;

  OllamaModelsResponse({required this.models});

  factory OllamaModelsResponse.fromJson(Map<String, dynamic> json) =>
      _$OllamaModelsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OllamaModelsResponseToJson(this);
}

/// 🔄 حالة تحميل النموذج
@JsonSerializable()
@HiveType(typeId: 1)
class ModelPullStatus extends HiveObject {
  @HiveField(0)
  final String modelName;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final int? total;

  @HiveField(3)
  final int? completed;

  @HiveField(4)
  final String? digest;

  @HiveField(5)
  final DateTime timestamp;

  ModelPullStatus({
    required this.modelName,
    required this.status,
    this.total,
    this.completed,
    this.digest,
    required this.timestamp,
  });

  factory ModelPullStatus.fromJson(Map<String, dynamic> json) =>
      _$ModelPullStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ModelPullStatusToJson(this);

  /// 📊 نسبة التقدم
  double get progress {
    if (total == null || completed == null || total == 0) return 0.0;
    return completed! / total!;
  }

  /// 📈 نسبة التقدم كنسبة مئوية
  String get progressPercentage {
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  /// ✅ هل اكتمل التحميل؟
  bool get isCompleted {
    return status == 'success' || progress >= 1.0;
  }

  /// ❌ هل فشل التحميل؟
  bool get isFailed {
    return status == 'error' || status == 'failed';
  }
}

/// ⚙️ معاملات النموذج
@JsonSerializable()
@HiveType(typeId: 2)
class ModelParameters extends HiveObject {
  @HiveField(0)
  final double temperature;

  @HiveField(1)
  final double topP;

  @HiveField(2)
  final int topK;

  @HiveField(3)
  final double repeatPenalty;

  @HiveField(4)
  final int numPredict;

  @HiveField(5)
  final int numCtx;

  @HiveField(6)
  final String? stop;

  @HiveField(7)
  final int? seed;

  @HiveField(8)
  final double? frequencyPenalty;

  @HiveField(9)
  final double? presencePenalty;

  ModelParameters({
    this.temperature = 0.7,
    this.topP = 0.9,
    this.topK = 40,
    this.repeatPenalty = 1.1,
    this.numPredict = -1,
    this.numCtx = 2048,
    this.stop,
    this.seed,
    this.frequencyPenalty,
    this.presencePenalty,
  });

  factory ModelParameters.fromJson(Map<String, dynamic> json) =>
      _$ModelParametersFromJson(json);
  Map<String, dynamic> toJson() => _$ModelParametersToJson(this);

  /// 🔄 نسخ المعاملات مع تحديثات
  ModelParameters copyWith({
    double? temperature,
    double? topP,
    int? topK,
    double? repeatPenalty,
    int? numPredict,
    int? numCtx,
    String? stop,
    int? seed,
    double? frequencyPenalty,
    double? presencePenalty,
  }) {
    return ModelParameters(
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      repeatPenalty: repeatPenalty ?? this.repeatPenalty,
      numPredict: numPredict ?? this.numPredict,
      numCtx: numCtx ?? this.numCtx,
      stop: stop ?? this.stop,
      seed: seed ?? this.seed,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      presencePenalty: presencePenalty ?? this.presencePenalty,
    );
  }

  /// 📊 تحويل إلى خريطة للإرسال إلى API
  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{
      'temperature': temperature,
      'top_p': topP,
      'top_k': topK,
      'repeat_penalty': repeatPenalty,
      'num_predict': numPredict,
      'num_ctx': numCtx,
    };

    if (stop != null) map['stop'] = stop;
    if (seed != null) map['seed'] = seed;
    if (frequencyPenalty != null) map['frequency_penalty'] = frequencyPenalty;
    if (presencePenalty != null) map['presence_penalty'] = presencePenalty;

    return map;
  }
}

/// 📊 إحصائيات النموذج
@JsonSerializable()
@HiveType(typeId: 3)
class ModelStats extends HiveObject {
  @HiveField(0)
  final String modelName;

  @HiveField(1)
  final int totalMessages;

  @HiveField(2)
  final int totalTokens;

  @HiveField(3)
  final double averageResponseTime;

  @HiveField(4)
  final DateTime firstUsed;

  @HiveField(5)
  final DateTime lastUsed;

  @HiveField(6)
  final Map<String, int> dailyUsage;

  @HiveField(7)
  final double rating;

  @HiveField(8)
  final int errorCount;

  ModelStats({
    required this.modelName,
    this.totalMessages = 0,
    this.totalTokens = 0,
    this.averageResponseTime = 0.0,
    required this.firstUsed,
    required this.lastUsed,
    this.dailyUsage = const {},
    this.rating = 0.0,
    this.errorCount = 0,
  });

  factory ModelStats.fromJson(Map<String, dynamic> json) =>
      _$ModelStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ModelStatsToJson(this);

  /// 📈 معدل الاستخدام اليومي
  double get dailyAverageUsage {
    if (dailyUsage.isEmpty) return 0.0;
    final total = dailyUsage.values.reduce((a, b) => a + b);
    return total / dailyUsage.length;
  }

  /// 🎯 معدل النجاح
  double get successRate {
    if (totalMessages == 0) return 0.0;
    return (totalMessages - errorCount) / totalMessages;
  }

  /// ⭐ تقييم النموذج
  String get ratingText {
    if (rating >= 4.5) return 'ممتاز';
    if (rating >= 4.0) return 'جيد جداً';
    if (rating >= 3.0) return 'جيد';
    if (rating >= 2.0) return 'مقبول';
    return 'ضعيف';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OllamaModelAdapter extends TypeAdapter<OllamaModel> {
  @override
  final int typeId = 0;

  @override
  OllamaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OllamaModel(
      name: fields[0] as String,
      tag: fields[1] as String?,
      size: fields[2] as int?,
      digest: fields[3] as String?,
      modifiedAt: fields[4] as DateTime?,
      details: (fields[5] as Map?)?.cast<String, dynamic>(),
      description: fields[6] as String?,
      capabilities: (fields[7] as List?)?.cast<String>(),
      isDownloaded: fields[8] as bool,
      isFavorite: fields[9] as bool,
      usageCount: fields[10] as int,
      lastUsed: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OllamaModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.digest)
      ..writeByte(4)
      ..write(obj.modifiedAt)
      ..writeByte(5)
      ..write(obj.details)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.capabilities)
      ..writeByte(8)
      ..write(obj.isDownloaded)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.usageCount)
      ..writeByte(11)
      ..write(obj.lastUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OllamaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelPullStatusAdapter extends TypeAdapter<ModelPullStatus> {
  @override
  final int typeId = 1;

  @override
  ModelPullStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelPullStatus(
      modelName: fields[0] as String,
      status: fields[1] as String,
      total: fields[2] as int?,
      completed: fields[3] as int?,
      digest: fields[4] as String?,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ModelPullStatus obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.modelName)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.digest)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelPullStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelParametersAdapter extends TypeAdapter<ModelParameters> {
  @override
  final int typeId = 2;

  @override
  ModelParameters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelParameters(
      temperature: fields[0] as double,
      topP: fields[1] as double,
      topK: fields[2] as int,
      repeatPenalty: fields[3] as double,
      numPredict: fields[4] as int,
      numCtx: fields[5] as int,
      stop: fields[6] as String?,
      seed: fields[7] as int?,
      frequencyPenalty: fields[8] as double?,
      presencePenalty: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelParameters obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.topP)
      ..writeByte(2)
      ..write(obj.topK)
      ..writeByte(3)
      ..write(obj.repeatPenalty)
      ..writeByte(4)
      ..write(obj.numPredict)
      ..writeByte(5)
      ..write(obj.numCtx)
      ..writeByte(6)
      ..write(obj.stop)
      ..writeByte(7)
      ..write(obj.seed)
      ..writeByte(8)
      ..write(obj.frequencyPenalty)
      ..writeByte(9)
      ..write(obj.presencePenalty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelParametersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelStatsAdapter extends TypeAdapter<ModelStats> {
  @override
  final int typeId = 3;

  @override
  ModelStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelStats(
      modelName: fields[0] as String,
      totalMessages: fields[1] as int,
      totalTokens: fields[2] as int,
      averageResponseTime: fields[3] as double,
      firstUsed: fields[4] as DateTime,
      lastUsed: fields[5] as DateTime,
      dailyUsage: (fields[6] as Map).cast<String, int>(),
      rating: fields[7] as double,
      errorCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelStats obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.modelName)
      ..writeByte(1)
      ..write(obj.totalMessages)
      ..writeByte(2)
      ..write(obj.totalTokens)
      ..writeByte(3)
      ..write(obj.averageResponseTime)
      ..writeByte(4)
      ..write(obj.firstUsed)
      ..writeByte(5)
      ..write(obj.lastUsed)
      ..writeByte(6)
      ..write(obj.dailyUsage)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.errorCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OllamaModel _$OllamaModelFromJson(Map<String, dynamic> json) => OllamaModel(
      name: json['name'] as String,
      tag: json['tag'] as String?,
      size: (json['size'] as num?)?.toInt(),
      digest: json['digest'] as String?,
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
      details: json['details'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      capabilities: (json['capabilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isDownloaded: json['isDownloaded'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$OllamaModelToJson(OllamaModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tag': instance.tag,
      'size': instance.size,
      'digest': instance.digest,
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
      'details': instance.details,
      'description': instance.description,
      'capabilities': instance.capabilities,
      'isDownloaded': instance.isDownloaded,
      'isFavorite': instance.isFavorite,
      'usageCount': instance.usageCount,
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };

OllamaModelsResponse _$OllamaModelsResponseFromJson(
        Map<String, dynamic> json) =>
    OllamaModelsResponse(
      models: (json['models'] as List<dynamic>)
          .map((e) => OllamaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OllamaModelsResponseToJson(
        OllamaModelsResponse instance) =>
    <String, dynamic>{
      'models': instance.models,
    };

ModelPullStatus _$ModelPullStatusFromJson(Map<String, dynamic> json) =>
    ModelPullStatus(
      modelName: json['modelName'] as String,
      status: json['status'] as String,
      total: (json['total'] as num?)?.toInt(),
      completed: (json['completed'] as num?)?.toInt(),
      digest: json['digest'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ModelPullStatusToJson(ModelPullStatus instance) =>
    <String, dynamic>{
      'modelName': instance.modelName,
      'status': instance.status,
      'total': instance.total,
      'completed': instance.completed,
      'digest': instance.digest,
      'timestamp': instance.timestamp.toIso8601String(),
    };

ModelParameters _$ModelParametersFromJson(Map<String, dynamic> json) =>
    ModelParameters(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      topP: (json['topP'] as num?)?.toDouble() ?? 0.9,
      topK: (json['topK'] as num?)?.toInt() ?? 40,
      repeatPenalty: (json['repeatPenalty'] as num?)?.toDouble() ?? 1.1,
      numPredict: (json['numPredict'] as num?)?.toInt() ?? -1,
      numCtx: (json['numCtx'] as num?)?.toInt() ?? 2048,
      stop: json['stop'] as String?,
      seed: (json['seed'] as num?)?.toInt(),
      frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble(),
      presencePenalty: (json['presencePenalty'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ModelParametersToJson(ModelParameters instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'topP': instance.topP,
      'topK': instance.topK,
      'repeatPenalty': instance.repeatPenalty,
      'numPredict': instance.numPredict,
      'numCtx': instance.numCtx,
      'stop': instance.stop,
      'seed': instance.seed,
      'frequencyPenalty': instance.frequencyPenalty,
      'presencePenalty': instance.presencePenalty,
    };

ModelStats _$ModelStatsFromJson(Map<String, dynamic> json) => ModelStats(
      modelName: json['modelName'] as String,
      totalMessages: (json['totalMessages'] as num?)?.toInt() ?? 0,
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
      averageResponseTime:
          (json['averageResponseTime'] as num?)?.toDouble() ?? 0.0,
      firstUsed: DateTime.parse(json['firstUsed'] as String),
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      dailyUsage: (json['dailyUsage'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ModelStatsToJson(ModelStats instance) =>
    <String, dynamic>{
      'modelName': instance.modelName,
      'totalMessages': instance.totalMessages,
      'totalTokens': instance.totalTokens,
      'averageResponseTime': instance.averageResponseTime,
      'firstUsed': instance.firstUsed.toIso8601String(),
      'lastUsed': instance.lastUsed.toIso8601String(),
      'dailyUsage': instance.dailyUsage,
      'rating': instance.rating,
      'errorCount': instance.errorCount,
    };

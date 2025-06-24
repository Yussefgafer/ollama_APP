// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConversationAdapter extends TypeAdapter<ChatConversation> {
  @override
  final int typeId = 4;

  @override
  ChatConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConversation(
      id: fields[0] as String?,
      title: fields[1] as String,
      modelName: fields[2] as String,
      messages: (fields[3] as List?)?.cast<ChatMessage>(),
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      isPinned: fields[6] as bool,
      isArchived: fields[7] as bool,
      tags: (fields[8] as List).cast<String>(),
      summary: fields[9] as String?,
      metadata: (fields[10] as Map?)?.cast<String, dynamic>(),
      messageCount: fields[11] as int?,
      lastMessagePreview: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConversation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.modelName)
      ..writeByte(3)
      ..write(obj.messages)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isPinned)
      ..writeByte(7)
      ..write(obj.isArchived)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.summary)
      ..writeByte(10)
      ..write(obj.metadata)
      ..writeByte(11)
      ..write(obj.messageCount)
      ..writeByte(12)
      ..write(obj.lastMessagePreview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 5;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      id: fields[0] as String?,
      content: fields[1] as String,
      role: fields[2] as MessageRole,
      timestamp: fields[3] as DateTime?,
      status: fields[4] as MessageStatus,
      attachments: (fields[5] as List?)?.cast<MessageAttachment>(),
      parentId: fields[6] as String?,
      metadata: (fields[7] as Map?)?.cast<String, dynamic>(),
      isEdited: fields[8] as bool,
      editedAt: fields[9] as DateTime?,
      isBookmarked: fields[10] as bool,
      tokenCount: fields[11] as int?,
      responseTime: fields[12] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.attachments)
      ..writeByte(6)
      ..write(obj.parentId)
      ..writeByte(7)
      ..write(obj.metadata)
      ..writeByte(8)
      ..write(obj.isEdited)
      ..writeByte(9)
      ..write(obj.editedAt)
      ..writeByte(10)
      ..write(obj.isBookmarked)
      ..writeByte(11)
      ..write(obj.tokenCount)
      ..writeByte(12)
      ..write(obj.responseTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageAttachmentAdapter extends TypeAdapter<MessageAttachment> {
  @override
  final int typeId = 8;

  @override
  MessageAttachment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageAttachment(
      id: fields[0] as String?,
      type: fields[1] as AttachmentType,
      path: fields[2] as String,
      name: fields[3] as String?,
      size: fields[4] as int?,
      mimeType: fields[5] as String?,
      metadata: (fields[6] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageAttachment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.mimeType)
      ..writeByte(6)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAttachmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageRoleAdapter extends TypeAdapter<MessageRole> {
  @override
  final int typeId = 6;

  @override
  MessageRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageRole.user;
      case 1:
        return MessageRole.assistant;
      case 2:
        return MessageRole.system;
      case 3:
        return MessageRole.error;
      default:
        return MessageRole.user;
    }
  }

  @override
  void write(BinaryWriter writer, MessageRole obj) {
    switch (obj) {
      case MessageRole.user:
        writer.writeByte(0);
        break;
      case MessageRole.assistant:
        writer.writeByte(1);
        break;
      case MessageRole.system:
        writer.writeByte(2);
        break;
      case MessageRole.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageStatusAdapter extends TypeAdapter<MessageStatus> {
  @override
  final int typeId = 7;

  @override
  MessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatus.sending;
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.delivered;
      case 3:
        return MessageStatus.failed;
      case 4:
        return MessageStatus.streaming;
      default:
        return MessageStatus.sending;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    switch (obj) {
      case MessageStatus.sending:
        writer.writeByte(0);
        break;
      case MessageStatus.sent:
        writer.writeByte(1);
        break;
      case MessageStatus.delivered:
        writer.writeByte(2);
        break;
      case MessageStatus.failed:
        writer.writeByte(3);
        break;
      case MessageStatus.streaming:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttachmentTypeAdapter extends TypeAdapter<AttachmentType> {
  @override
  final int typeId = 9;

  @override
  AttachmentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttachmentType.image;
      case 1:
        return AttachmentType.audio;
      case 2:
        return AttachmentType.video;
      case 3:
        return AttachmentType.document;
      case 4:
        return AttachmentType.file;
      default:
        return AttachmentType.image;
    }
  }

  @override
  void write(BinaryWriter writer, AttachmentType obj) {
    switch (obj) {
      case AttachmentType.image:
        writer.writeByte(0);
        break;
      case AttachmentType.audio:
        writer.writeByte(1);
        break;
      case AttachmentType.video:
        writer.writeByte(2);
        break;
      case AttachmentType.document:
        writer.writeByte(3);
        break;
      case AttachmentType.file:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) =>
    ChatConversation(
      id: json['id'] as String?,
      title: json['title'] as String,
      modelName: json['modelName'] as String,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      summary: json['summary'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      messageCount: (json['messageCount'] as num?)?.toInt(),
      lastMessagePreview: json['lastMessagePreview'] as String?,
    );

Map<String, dynamic> _$ChatConversationToJson(ChatConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'modelName': instance.modelName,
      'messages': instance.messages,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isPinned': instance.isPinned,
      'isArchived': instance.isArchived,
      'tags': instance.tags,
      'summary': instance.summary,
      'metadata': instance.metadata,
      'messageCount': instance.messageCount,
      'lastMessagePreview': instance.lastMessagePreview,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String?,
      content: json['content'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      parentId: json['parentId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      tokenCount: (json['tokenCount'] as num?)?.toInt(),
      responseTime: (json['responseTime'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status]!,
      'attachments': instance.attachments,
      'parentId': instance.parentId,
      'metadata': instance.metadata,
      'isEdited': instance.isEdited,
      'editedAt': instance.editedAt?.toIso8601String(),
      'isBookmarked': instance.isBookmarked,
      'tokenCount': instance.tokenCount,
      'responseTime': instance.responseTime,
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
  MessageRole.error: 'error',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.failed: 'failed',
  MessageStatus.streaming: 'streaming',
};

MessageAttachment _$MessageAttachmentFromJson(Map<String, dynamic> json) =>
    MessageAttachment(
      id: json['id'] as String?,
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
      path: json['path'] as String,
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageAttachmentToJson(MessageAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'metadata': instance.metadata,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.audio: 'audio',
  AttachmentType.video: 'video',
  AttachmentType.document: 'document',
  AttachmentType.file: 'file',
};

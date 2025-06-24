// 💬 نماذج بيانات المحادثة
// يحتوي على جميع النماذج المطلوبة لإدارة المحادثات والرسائل

import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'chat_models.g.dart';

/// 💬 نموذج المحادثة الأساسي
@JsonSerializable()
@HiveType(typeId: 4)
class ChatConversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String modelName;

  @HiveField(3)
  final List<ChatMessage> messages;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final bool isPinned;

  @HiveField(7)
  final bool isArchived;

  @HiveField(8)
  final List<String> tags;

  @HiveField(9)
  final String? summary;

  @HiveField(10)
  final Map<String, dynamic>? metadata;

  @HiveField(11)
  final int messageCount;

  @HiveField(12)
  final String? lastMessagePreview;

  ChatConversation({
    String? id,
    required this.title,
    required this.modelName,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isPinned = false,
    this.isArchived = false,
    this.tags = const [],
    this.summary,
    this.metadata,
    int? messageCount,
    this.lastMessagePreview,
  }) : id = id ?? const Uuid().v4(),
       messages = messages ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       messageCount = messageCount ?? (messages?.length ?? 0);

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConversationToJson(this);

  /// 📊 إحصائيات المحادثة
  int get totalMessages => messages.length;
  int get userMessages =>
      messages.where((m) => m.role == MessageRole.user).length;
  int get assistantMessages =>
      messages.where((m) => m.role == MessageRole.assistant).length;

  /// 🕒 آخر رسالة
  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// 📝 معاينة آخر رسالة
  String get lastMessageText {
    if (lastMessagePreview != null) return lastMessagePreview!;
    final last = lastMessage;
    if (last == null) return 'لا توجد رسائل';
    return last.content.length > 50
        ? '${last.content.substring(0, 50)}...'
        : last.content;
  }

  /// 🎨 لون المحادثة
  int get colorCode {
    final hash = id.hashCode;
    return 0xFF000000 + (hash & 0xFFFFFF);
  }

  /// ⏱️ وقت آخر نشاط
  String get lastActivityTime {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    if (diff.inDays < 30) return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
    return 'منذ ${(diff.inDays / 30).floor()} شهر';
  }

  /// 🔄 نسخ المحادثة مع تحديثات
  ChatConversation copyWith({
    String? title,
    String? modelName,
    List<ChatMessage>? messages,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    List<String>? tags,
    String? summary,
    Map<String, dynamic>? metadata,
    String? lastMessagePreview,
  }) {
    return ChatConversation(
      id: id,
      title: title ?? this.title,
      modelName: modelName ?? this.modelName,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      tags: tags ?? this.tags,
      summary: summary ?? this.summary,
      metadata: metadata ?? this.metadata,
      messageCount: messages?.length ?? this.messages.length,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
    );
  }
}

/// 📨 نموذج الرسالة
@JsonSerializable()
@HiveType(typeId: 5)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final MessageRole role;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final MessageStatus status;

  @HiveField(5)
  final List<MessageAttachment>? attachments;

  @HiveField(6)
  final String? parentId;

  @HiveField(7)
  final Map<String, dynamic>? metadata;

  @HiveField(8)
  final bool isEdited;

  @HiveField(9)
  final DateTime? editedAt;

  @HiveField(10)
  final bool isBookmarked;

  @HiveField(11)
  final int? tokenCount;

  @HiveField(12)
  final double? responseTime;

  ChatMessage({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.status = MessageStatus.sent,
    this.attachments,
    this.parentId,
    this.metadata,
    this.isEdited = false,
    this.editedAt,
    this.isBookmarked = false,
    this.tokenCount,
    this.responseTime,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  /// 🕒 وقت الرسالة المنسق
  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return '${diff.inMinutes}د';
    if (diff.inHours < 24) return '${diff.inHours}س';
    return '${timestamp.day}/${timestamp.month}';
  }

  /// 📊 عدد الكلمات
  int get wordCount => content.split(' ').length;

  /// 📝 معاينة المحتوى
  String get preview {
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  /// 🎨 لون الرسالة حسب النوع
  int get colorCode {
    switch (role) {
      case MessageRole.user:
        return 0xFF2196F3; // أزرق
      case MessageRole.assistant:
        return 0xFF4CAF50; // أخضر
      case MessageRole.system:
        return 0xFFFF9800; // برتقالي
      case MessageRole.error:
        return 0xFFF44336; // أحمر
    }
  }

  /// 🔄 نسخ الرسالة مع تحديثات
  ChatMessage copyWith({
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    MessageStatus? status,
    List<MessageAttachment>? attachments,
    String? parentId,
    Map<String, dynamic>? metadata,
    bool? isEdited,
    DateTime? editedAt,
    bool? isBookmarked,
    int? tokenCount,
    double? responseTime,
  }) {
    return ChatMessage(
      id: id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      parentId: parentId ?? this.parentId,
      metadata: metadata ?? this.metadata,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tokenCount: tokenCount ?? this.tokenCount,
      responseTime: responseTime ?? this.responseTime,
    );
  }
}

/// 🎭 أدوار الرسائل
@HiveType(typeId: 6)
enum MessageRole {
  @HiveField(0)
  user,
  @HiveField(1)
  assistant,
  @HiveField(2)
  system,
  @HiveField(3)
  error,
}

/// 📊 حالات الرسائل
@HiveType(typeId: 7)
enum MessageStatus {
  @HiveField(0)
  sending,
  @HiveField(1)
  sent,
  @HiveField(2)
  delivered,
  @HiveField(3)
  failed,
  @HiveField(4)
  streaming,
}

/// 📎 مرفقات الرسائل
@JsonSerializable()
@HiveType(typeId: 8)
class MessageAttachment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final AttachmentType type;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final String? name;

  @HiveField(4)
  final int? size;

  @HiveField(5)
  final String? mimeType;

  @HiveField(6)
  final Map<String, dynamic>? metadata;

  MessageAttachment({
    String? id,
    required this.type,
    required this.path,
    this.name,
    this.size,
    this.mimeType,
    this.metadata,
  }) : id = id ?? const Uuid().v4();

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$MessageAttachmentToJson(this);

  /// 📊 حجم الملف المنسق
  String get formattedSize {
    if (size == null) return 'غير معروف';

    const units = ['B', 'KB', 'MB', 'GB'];
    double bytes = size!.toDouble();
    int unitIndex = 0;

    while (bytes >= 1024 && unitIndex < units.length - 1) {
      bytes /= 1024;
      unitIndex++;
    }

    return '${bytes.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}

/// 📎 أنواع المرفقات
@HiveType(typeId: 9)
enum AttachmentType {
  @HiveField(0)
  image,
  @HiveField(1)
  audio,
  @HiveField(2)
  video,
  @HiveField(3)
  document,
  @HiveField(4)
  file,
}

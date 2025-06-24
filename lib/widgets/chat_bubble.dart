// 💬 فقاعة المحادثة - عرض الرسائل بتصميم أنيق
// تدعم أنواع مختلفة من الرسائل مع تأثيرات بصرية متقدمة

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/chat_models.dart';
import '../constants/app_constants.dart';

/// 💬 فقاعة المحادثة الرئيسية
class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isLastMessage;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.isLastMessage = false,
    this.onLongPress,
    this.onTap,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == MessageRole.user;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: widget.isLastMessage ? 16 : 8,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            onLongPress: () {
              HapticFeedback.mediumImpact();
              widget.onLongPress?.call();
            },
            onTapDown: (_) {
              _scaleController.forward();
            },
            onTapUp: (_) {
              _scaleController.reverse();
            },
            onTapCancel: () {
              _scaleController.reverse();
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width *
                      AppConstants.chatBubbleMaxWidth,
                ),
                decoration: BoxDecoration(
                  color: _getBubbleColor(theme, isUser),
                  borderRadius: _getBubbleBorderRadius(isUser),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(theme, isUser),
                    if (widget.message.attachments?.isNotEmpty == true)
                      _buildAttachments(theme),
                    _buildMessageFooter(theme, isUser),
                  ],
                ),
              ),
            ),
          ),
          if (widget.message.status == MessageStatus.failed)
            _buildErrorIndicator(theme),
        ],
      ),
    );
  }

  /// 🎨 الحصول على لون الفقاعة
  Color _getBubbleColor(ThemeData theme, bool isUser) {
    if (widget.message.status == MessageStatus.failed) {
      return theme.colorScheme.errorContainer;
    }

    return isUser
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
  }

  /// 🔄 الحصول على شكل الفقاعة
  BorderRadius _getBubbleBorderRadius(bool isUser) {
    const radius = AppConstants.borderRadius;

    return BorderRadius.only(
      topLeft: const Radius.circular(radius),
      topRight: const Radius.circular(radius),
      bottomLeft: Radius.circular(isUser ? radius : 4),
      bottomRight: Radius.circular(isUser ? 4 : radius),
    );
  }

  /// 📝 بناء محتوى الرسالة
  Widget _buildMessageContent(ThemeData theme, bool isUser) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message.role == MessageRole.system)
            _buildSystemMessageHeader(theme),
          _buildMessageText(theme, isUser),
          if (widget.message.status == MessageStatus.streaming)
            _buildStreamingIndicator(theme),
        ],
      ),
    );
  }

  /// 🔧 بناء رأس رسالة النظام
  Widget _buildSystemMessageHeader(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.settings, size: 16, color: theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text(
            'رسالة النظام',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 بناء نص الرسالة
  Widget _buildMessageText(ThemeData theme, bool isUser) {
    final textColor = isUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    // فحص إذا كان النص يحتوي على Markdown
    if (_containsMarkdown(widget.message.content)) {
      return MarkdownBody(
        data: widget.message.content,
        styleSheet: MarkdownStyleSheet(
          p: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          code: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
            color: textColor,
          ),
          codeblockDecoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          blockquoteDecoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 4),
            ),
          ),
        ),
        selectable: true,
      );
    }

    return SelectableText(
      widget.message.content,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        height: 1.4,
      ),
    );
  }

  /// 🔄 مؤشر البث المباشر
  Widget _buildStreamingIndicator(ThemeData theme) {
    return Container(
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'جاري الكتابة...',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: const Duration(seconds: 2));
  }

  /// 📎 بناء المرفقات
  Widget _buildAttachments(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.message.attachments!.map((attachment) {
          return _buildAttachmentChip(theme, attachment);
        }).toList(),
      ),
    );
  }

  /// 📎 بناء رقاقة المرفق
  Widget _buildAttachmentChip(ThemeData theme, MessageAttachment attachment) {
    IconData icon;
    switch (attachment.type) {
      case AttachmentType.image:
        icon = Icons.image;
        break;
      case AttachmentType.audio:
        icon = Icons.audiotrack;
        break;
      case AttachmentType.video:
        icon = Icons.videocam;
        break;
      case AttachmentType.document:
        icon = Icons.description;
        break;
      case AttachmentType.file:
        icon = Icons.attach_file;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(attachment.name ?? 'مرفق', style: theme.textTheme.labelSmall),
          if (attachment.size != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${attachment.formattedSize})',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 📊 بناء تذييل الرسالة
  Widget _buildMessageFooter(ThemeData theme, bool isUser) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.message.formattedTime,
            style: theme.textTheme.labelSmall?.copyWith(
              color:
                  (isUser
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant)
                      .withValues(alpha: 0.7),
            ),
          ),
          if (widget.message.isEdited) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.edit,
              size: 12,
              color:
                  (isUser
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant)
                      .withValues(alpha: 0.7),
            ),
          ],
          if (widget.message.isBookmarked) ...[
            const SizedBox(width: 4),
            Icon(Icons.bookmark, size: 12, color: theme.colorScheme.primary),
          ],
          if (isUser) ...[
            const SizedBox(width: 4),
            _buildMessageStatusIcon(theme),
          ],
        ],
      ),
    );
  }

  /// 📊 بناء أيقونة حالة الرسالة
  Widget _buildMessageStatusIcon(ThemeData theme) {
    IconData icon;
    Color color;

    switch (widget.message.status) {
      case MessageStatus.sending:
        icon = Icons.schedule;
        color = theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7);
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        color = theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7);
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = theme.colorScheme.primary;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = theme.colorScheme.error;
        break;
      case MessageStatus.streaming:
        icon = Icons.more_horiz;
        color = theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7);
        break;
    }

    return Icon(icon, size: 12, color: color);
  }

  /// ❌ بناء مؤشر الخطأ
  Widget _buildErrorIndicator(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 4),
          Text(
            'فشل في الإرسال',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // إعادة المحاولة
            },
            child: Text(
              'إعادة المحاولة',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔍 فحص إذا كان النص يحتوي على Markdown
  bool _containsMarkdown(String text) {
    final markdownPatterns = [
      RegExp(r'\*\*.*?\*\*'), // Bold
      RegExp(r'\*.*?\*'), // Italic
      RegExp(r'`.*?`'), // Inline code
      RegExp(r'```[\s\S]*?```'), // Code block
      RegExp(r'^#{1,6}\s'), // Headers
      RegExp(r'^\s*[-*+]\s'), // Lists
      RegExp(r'^\s*\d+\.\s'), // Numbered lists
      RegExp(r'^\s*>\s'), // Blockquotes
    ];

    return markdownPatterns.any((pattern) => pattern.hasMatch(text));
  }
}

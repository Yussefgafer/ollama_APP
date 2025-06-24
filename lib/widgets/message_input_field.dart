// 📝 حقل إدخال الرسائل - واجهة كتابة وإرسال الرسائل
// يدعم النص والصوت والصور مع مميزات متقدمة

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';

/// 📝 حقل إدخال الرسائل الرئيسي
class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSend;
  final Function(bool)? onTypingChanged;
  final VoidCallback? onAttachmentPressed;
  final VoidCallback? onVoicePressed;
  final bool enabled;
  final String? hintText;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.onTypingChanged,
    this.onAttachmentPressed,
    this.onVoicePressed,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField>
    with TickerProviderStateMixin {
  late AnimationController _sendButtonController;
  late Animation<double> _sendButtonAnimation;
  late AnimationController _attachmentController;

  bool _hasText = false;
  bool _isRecording = false;
  Timer? _typingTimer;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _sendButtonAnimation = CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.easeInOut,
    );

    _attachmentController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    widget.controller.addListener(_onTextChanged);
    _hasText = widget.controller.text.isNotEmpty;

    if (_hasText) {
      _sendButtonController.forward();
    }
  }

  @override
  void dispose() {
    _sendButtonController.dispose();
    _attachmentController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;

    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }

    // إشعار الكتابة
    _typingTimer?.cancel();
    if (hasText) {
      widget.onTypingChanged?.call(true);
      _typingTimer = Timer(const Duration(seconds: 2), () {
        widget.onTypingChanged?.call(false);
      });
    } else {
      widget.onTypingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _buildAttachmentButton(theme),
          const SizedBox(width: 8),
          Expanded(child: _buildTextField(theme)),
          const SizedBox(width: 8),
          _buildActionButton(theme),
        ],
      ),
    );
  }

  /// 📎 بناء زر المرفقات
  Widget _buildAttachmentButton(ThemeData theme) {
    return GestureDetector(
      onTap: _showAttachmentOptions,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.attach_file,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    ).animate().scale(duration: const Duration(milliseconds: 200));
  }

  /// 📝 بناء حقل النص
  Widget _buildTextField(ThemeData theme) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      maxLines: 5,
      minLines: 1,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'اكتب رسالتك هنا...',
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      style: theme.textTheme.bodyMedium,
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          _sendMessage();
        }
      },
    );
  }

  /// 🎯 بناء زر الإجراء (إرسال/صوت)
  Widget _buildActionButton(ThemeData theme) {
    return GestureDetector(
      onTap: _hasText ? _sendMessage : _toggleVoiceRecording,
      onLongPress: !_hasText ? _startVoiceRecording : null,
      onLongPressUp: !_hasText ? _stopVoiceRecording : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _hasText || _isRecording
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ScaleTransition(
          scale: _sendButtonAnimation,
          child: Icon(
            _hasText
                ? Icons.send
                : _isRecording
                ? Icons.stop
                : Icons.mic,
            color: _hasText || _isRecording
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// 📤 إرسال الرسالة
  void _sendMessage() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSend(text);
      widget.controller.clear();
      _typingTimer?.cancel();
      widget.onTypingChanged?.call(false);

      // تأثير اهتزاز
      HapticFeedback.lightImpact();
    }
  }

  /// 📎 عرض خيارات المرفقات
  void _showAttachmentOptions() {
    _attachmentController.forward();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentSheet(),
    ).then((_) {
      _attachmentController.reverse();
    });
  }

  /// 📋 بناء ورقة المرفقات
  Widget _buildAttachmentSheet() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'إضافة مرفق',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                theme,
                Icons.photo_camera,
                'كاميرا',
                () => _pickImage(ImageSource.camera),
              ),
              _buildAttachmentOption(
                theme,
                Icons.photo_library,
                'معرض الصور',
                () => _pickImage(ImageSource.gallery),
              ),
              _buildAttachmentOption(
                theme,
                Icons.insert_drive_file,
                'ملف',
                _pickFile,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ).animate().slideY(
      begin: 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );
  }

  /// 📎 بناء خيار المرفق
  Widget _buildAttachmentOption(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 📷 اختيار صورة
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: (AppConstants.imageQuality * 100).toInt(),
      );

      if (image != null) {
        // معالجة الصورة المختارة
        _handleImageSelected(image);
      }
    } catch (e) {
      _showError('خطأ في اختيار الصورة: $e');
    }
  }

  /// 📁 اختيار ملف
  Future<void> _pickFile() async {
    try {
      // استخدام file_picker لاختيار الملفات
      // final result = await FilePicker.platform.pickFiles();
      // if (result != null) {
      //   _handleFileSelected(result.files.first);
      // }
    } catch (e) {
      _showError('خطأ في اختيار الملف: $e');
    }
  }

  /// 📷 معالجة الصورة المختارة
  void _handleImageSelected(XFile image) {
    // معالجة الصورة وإضافتها كمرفق
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم اختيار الصورة: ${image.name}')));
  }

  /// 🎤 تبديل تسجيل الصوت
  void _toggleVoiceRecording() {
    if (_isRecording) {
      _stopVoiceRecording();
    } else {
      _startVoiceRecording();
    }
  }

  /// 🎤 بدء تسجيل الصوت
  void _startVoiceRecording() {
    setState(() {
      _isRecording = true;
    });

    HapticFeedback.mediumImpact();

    // بدء التسجيل الفعلي
    // يمكن استخدام مكتبة record أو speech_to_text
  }

  /// ⏹️ إيقاف تسجيل الصوت
  void _stopVoiceRecording() {
    setState(() {
      _isRecording = false;
    });

    HapticFeedback.lightImpact();

    // إيقاف التسجيل ومعالجة الملف الصوتي
  }

  /// ❌ عرض رسالة خطأ
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

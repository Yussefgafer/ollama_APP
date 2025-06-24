// 💬 شاشة المحادثة - واجهة التفاعل مع الذكاء الاصطناعي
// تحتوي على عرض الرسائل وإدخال النصوص والمميزات المتقدمة

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/ollama_provider.dart';
import '../models/chat_models.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input_field.dart';
import '../widgets/typing_indicator.dart';
import '../constants/app_constants.dart';

/// 💬 شاشة المحادثة الرئيسية
class ChatScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  late AnimationController _appBarAnimationController;

  bool _isAtBottom = true;
  bool _showScrollToBottom = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);
    _appBarAnimationController.forward();

    // تحديد المحادثة النشطة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OllamaProvider>(
        context,
        listen: false,
      ).selectConversation(widget.conversation);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _appBarAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100;

    if (_isAtBottom != isAtBottom) {
      setState(() {
        _isAtBottom = isAtBottom;
        _showScrollToBottom = !isAtBottom;
      });
    }
  }

  void _scrollToBottom({bool animate = true}) {
    if (_scrollController.hasClients) {
      if (animate) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<OllamaProvider>(
              builder: (context, provider, child) {
                final conversation =
                    provider.currentConversation ?? widget.conversation;

                return Stack(
                  children: [
                    _buildMessagesList(conversation),
                    if (_showScrollToBottom) _buildScrollToBottomButton(),
                    if (_isTyping) _buildTypingIndicator(),
                  ],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// 🎯 بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar() {
    final appBar = AppBar(
      title: Consumer<OllamaProvider>(
        builder: (context, provider, child) {
          final conversation =
              provider.currentConversation ?? widget.conversation;
          final model = provider.selectedModel;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (model != null)
                Text(
                  model.displayName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: _showChatOptions,
        ),
      ],
    );

    return PreferredSize(
      preferredSize: appBar.preferredSize,
      child: appBar
          .animate(controller: _appBarAnimationController)
          .slideY(begin: -1, curve: Curves.easeOutBack),
    );
  }

  /// 📋 بناء قائمة الرسائل
  Widget _buildMessagesList(ChatConversation conversation) {
    if (conversation.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: conversation.messages.length,
      itemBuilder: (context, index) {
        final message = conversation.messages[index];
        final isLastMessage = index == conversation.messages.length - 1;

        return ChatBubble(
          message: message,
          isLastMessage: isLastMessage,
          onLongPress: () => _showMessageOptions(message),
        ).animate().slideX(
          begin: message.role == MessageRole.user ? 1 : -1,
          delay: Duration(milliseconds: index * 50),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
        );
      },
    );
  }

  /// 📋 حالة فارغة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ).animate().scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 16),
          Text(
            'ابدأ المحادثة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          const SizedBox(height: 8),
          Text(
            'اكتب رسالتك أدناه لبدء المحادثة مع الذكاء الاصطناعي',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
        ],
      ),
    );
  }

  /// ⬇️ زر التمرير للأسفل
  Widget _buildScrollToBottomButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton.small(
        onPressed: () => _scrollToBottom(),
        child: const Icon(Icons.keyboard_arrow_down),
      ).animate().scale(duration: const Duration(milliseconds: 200)),
    );
  }

  /// ⌨️ مؤشر الكتابة
  Widget _buildTypingIndicator() {
    return const Positioned(bottom: 16, left: 16, child: TypingIndicator());
  }

  /// 📝 بناء حقل إدخال الرسالة
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: MessageInputField(
          controller: _messageController,
          focusNode: _messageFocusNode,
          onSend: _sendMessage,
          onTypingChanged: (isTyping) {
            setState(() {
              _isTyping = isTyping;
            });
          },
        ),
      ),
    );
  }

  /// 📤 إرسال رسالة
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final provider = Provider.of<OllamaProvider>(context, listen: false);

    try {
      // مسح حقل الإدخال
      _messageController.clear();

      // إخفاء لوحة المفاتيح
      _messageFocusNode.unfocus();

      // تأثير اهتزاز
      HapticFeedback.lightImpact();

      // إرسال الرسالة
      await provider.sendMessage(message.trim());

      // التمرير للأسفل
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إرسال الرسالة: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              onPressed: () => _sendMessage(message),
            ),
          ),
        );
      }
    }
  }

  /// ⚙️ عرض خيارات المحادثة
  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildChatOptionsSheet(),
    );
  }

  /// 📋 ورقة خيارات المحادثة
  Widget _buildChatOptionsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('تعديل العنوان'),
            onTap: () {
              Navigator.pop(context);
              _showEditTitleDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text('تغيير النموذج'),
            onTap: () {
              Navigator.pop(context);
              _showModelSelector();
            },
          ),
          ListTile(
            leading: const Icon(Icons.tune_outlined),
            title: const Text('إعدادات النموذج'),
            onTap: () {
              Navigator.pop(context);
              _showModelSettings();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('مشاركة المحادثة'),
            onTap: () {
              Navigator.pop(context);
              _shareConversation();
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('تصدير المحادثة'),
            onTap: () {
              Navigator.pop(context);
              _exportConversation();
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'حذف المحادثة',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
    );
  }

  /// ✏️ عرض حوار تعديل العنوان
  void _showEditTitleDialog() {
    final titleController = TextEditingController(
      text: widget.conversation.title,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل عنوان المحادثة'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'العنوان الجديد'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              // تحديث عنوان المحادثة
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// 🤖 عرض محدد النماذج
  void _showModelSelector() {
    // عرض قائمة النماذج المتاحة
  }

  /// ⚙️ عرض إعدادات النموذج
  void _showModelSettings() {
    // عرض إعدادات معاملات النموذج
  }

  /// 📤 مشاركة المحادثة
  void _shareConversation() {
    // مشاركة المحادثة
  }

  /// 📥 تصدير المحادثة
  void _exportConversation() {
    // تصدير المحادثة
  }

  /// 🗑️ عرض تأكيد الحذف
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: const Text(
          'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<OllamaProvider>(
                context,
                listen: false,
              ).deleteConversation(widget.conversation.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// 📝 عرض خيارات الرسالة
  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('نسخ النص'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('تم نسخ النص')));
              },
            ),
            if (message.role == MessageRole.assistant) ...[
              ListTile(
                leading: const Icon(Icons.volume_up_outlined),
                title: const Text('قراءة بصوت عالٍ'),
                onTap: () {
                  Navigator.pop(context);
                  // تشغيل TTS
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh_outlined),
                title: const Text('إعادة توليد'),
                onTap: () {
                  Navigator.pop(context);
                  // إعادة توليد الرد
                },
              ),
            ],
            ListTile(
              leading: Icon(
                message.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              ),
              title: Text(
                message.isBookmarked
                    ? 'إزالة الإشارة المرجعية'
                    : 'إضافة إشارة مرجعية',
              ),
              onTap: () {
                Navigator.pop(context);
                // تبديل الإشارة المرجعية
              },
            ),
          ],
        ),
      ),
    );
  }
}

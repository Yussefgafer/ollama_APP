// 🏠 الشاشة الرئيسية - واجهة التطبيق الأساسية
// تحتوي على التنقل الرئيسي وعرض المحادثات

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/ollama_provider.dart';
import '../models/chat_models.dart';
import '../widgets/custom_app_bar.dart';
import '../constants/app_constants.dart';
import 'chat_screen.dart';
import 'models_screen.dart';
import 'settings_screen.dart';

/// 🏠 الشاشة الرئيسية
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<Widget> _screens = [];
  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.chat_bubble_outline),
      selectedIcon: Icon(Icons.chat_bubble),
      label: 'المحادثات',
    ),
    const NavigationDestination(
      icon: Icon(Icons.smart_toy_outlined),
      selectedIcon: Icon(Icons.smart_toy),
      label: 'النماذج',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'الإعدادات',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    _screens.addAll([
      const ConversationsTab(),
      const ModelsScreen(),
      const SettingsScreen(),
    ]);

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // تأثير اهتزاز خفيف
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar:
          NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: _destinations,
            animationDuration: const Duration(milliseconds: 300),
          ).animate().slideY(
            begin: 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
          ),
      floatingActionButton: _currentIndex == 0
          ? ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton.extended(
                onPressed: _createNewChat,
                icon: const Icon(Icons.add),
                label: const Text('محادثة جديدة'),
                tooltip: 'إنشاء محادثة جديدة',
              ),
            )
          : null,
    );
  }

  /// 💬 إنشاء محادثة جديدة
  void _createNewChat() async {
    final ollamaProvider = Provider.of<OllamaProvider>(context, listen: false);

    try {
      final conversation = await ollamaProvider.createNewConversation();

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversation: conversation),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء المحادثة: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

/// 💬 تبويب المحادثات
class ConversationsTab extends StatefulWidget {
  const ConversationsTab({super.key});

  @override
  State<ConversationsTab> createState() => _ConversationsTabState();
}

class _ConversationsTabState extends State<ConversationsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _showSearch ? null : 'المحادثات',
        titleWidget: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'البحث في المحادثات...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'archive',
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text('المحادثات المؤرشفة'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download_outlined),
                  title: Text('تصدير المحادثات'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'backup',
                child: ListTile(
                  leading: Icon(Icons.backup_outlined),
                  title: Text('نسخ احتياطي'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<OllamaProvider>(
        builder: (context, provider, child) {
          final conversations = _searchQuery.isEmpty
              ? provider.conversations
              : provider.searchConversations(_searchQuery);

          if (provider.appState == AppState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (conversations.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.initialize();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ConversationCard(
                  conversation: conversation,
                  onTap: () => _openConversation(conversation),
                  onLongPress: () => _showConversationOptions(conversation),
                ).animate().slideX(
                  begin: 1,
                  delay: Duration(milliseconds: index * 50),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuart,
                );
              },
            ),
          );
        },
      ),
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
            _searchQuery.isEmpty
                ? 'لا توجد محادثات بعد'
                : 'لم يتم العثور على محادثات',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'ابدأ محادثة جديدة مع الذكاء الاصطناعي'
                : 'جرب كلمات بحث مختلفة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
        ],
      ),
    );
  }

  /// 🎯 فتح محادثة
  void _openConversation(ChatConversation conversation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversation: conversation),
      ),
    );
  }

  /// ⚙️ عرض خيارات المحادثة
  void _showConversationOptions(ChatConversation conversation) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          ConversationOptionsSheet(conversation: conversation),
    );
  }

  /// 📋 معالجة إجراءات القائمة
  void _handleMenuAction(String action) {
    switch (action) {
      case 'archive':
        // عرض المحادثات المؤرشفة
        break;
      case 'export':
        // تصدير المحادثات
        break;
      case 'backup':
        // إنشاء نسخة احتياطية
        break;
    }
  }
}

/// 🎴 بطاقة المحادثة
class ConversationCard extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundColor: Color(conversation.colorCode).withValues(alpha: 0.2),
          child: Icon(
            Icons.chat_bubble_outline,
            color: Color(conversation.colorCode),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (conversation.isPinned)
              Icon(Icons.push_pin, size: 16, color: theme.colorScheme.primary),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation.lastMessageText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  size: 12,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(conversation.modelName, style: theme.textTheme.labelSmall),
                const Spacer(),
                Text(
                  conversation.lastActivityTime,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (conversation.messageCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${conversation.messageCount}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 📋 ورقة خيارات المحادثة
class ConversationOptionsSheet extends StatelessWidget {
  final ChatConversation conversation;

  const ConversationOptionsSheet({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
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
            leading: Icon(
              conversation.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
            ),
            title: Text(conversation.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
            onTap: () {
              Provider.of<OllamaProvider>(
                context,
                listen: false,
              ).toggleConversationPin(conversation);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('تعديل العنوان'),
            onTap: () {
              Navigator.pop(context);
              // عرض حوار تعديل العنوان
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('مشاركة'),
            onTap: () {
              Navigator.pop(context);
              // مشاركة المحادثة
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: Text(conversation.isArchived ? 'إلغاء الأرشفة' : 'أرشفة'),
            onTap: () {
              Navigator.pop(context);
              // أرشفة المحادثة
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'حذف',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
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
              ).deleteConversation(conversation.id);
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
}

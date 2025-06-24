// 🤖 شاشة النماذج - إدارة وعرض نماذج الذكاء الاصطناعي

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/ollama_provider.dart';
import '../models/ollama_models.dart';
import '../widgets/custom_app_bar.dart';
import '../constants/app_constants.dart';

/// 🤖 شاشة النماذج الرئيسية
class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _showSearch ? null : 'النماذج',
        titleWidget: _showSearch
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'البحث في النماذج...',
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
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<OllamaProvider>(
                context,
                listen: false,
              ).refreshModels();
            },
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_model',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('إضافة نموذج'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'import_model',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('استيراد نموذج'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الكل', icon: Icon(Icons.apps)),
            Tab(text: 'المفضلة', icon: Icon(Icons.favorite)),
            Tab(text: 'التحميلات', icon: Icon(Icons.download)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllModelsTab(),
          _buildFavoriteModelsTab(),
          _buildDownloadsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModelDialog,
        tooltip: 'إضافة نموذج جديد',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 📋 تبويب جميع النماذج
  Widget _buildAllModelsTab() {
    return Consumer<OllamaProvider>(
      builder: (context, provider, child) {
        var models = provider.models;

        if (_searchQuery.isNotEmpty) {
          models = models
              .where(
                (model) =>
                    model.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    (model.description?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
        }

        if (provider.appState == AppState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (models.isEmpty) {
          return _buildEmptyState('لا توجد نماذج متاحة');
        }

        return RefreshIndicator(
          onRefresh: () => provider.refreshModels(),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return ModelCard(
                model: model,
                onTap: () => _selectModel(model),
                onFavoriteToggle: () => provider.toggleModelFavorite(model),
                onDelete: model.isDownloaded ? () => _deleteModel(model) : null,
                onDownload: !model.isDownloaded
                    ? () => _downloadModel(model)
                    : null,
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
    );
  }

  /// ⭐ تبويب النماذج المفضلة
  Widget _buildFavoriteModelsTab() {
    return Consumer<OllamaProvider>(
      builder: (context, provider, child) {
        final favoriteModels = provider.models
            .where((m) => m.isFavorite)
            .toList();

        if (favoriteModels.isEmpty) {
          return _buildEmptyState('لا توجد نماذج مفضلة');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: favoriteModels.length,
          itemBuilder: (context, index) {
            final model = favoriteModels[index];
            return ModelCard(
              model: model,
              onTap: () => _selectModel(model),
              onFavoriteToggle: () => provider.toggleModelFavorite(model),
              onDelete: model.isDownloaded ? () => _deleteModel(model) : null,
            );
          },
        );
      },
    );
  }

  /// 📥 تبويب التحميلات
  Widget _buildDownloadsTab() {
    return Consumer<OllamaProvider>(
      builder: (context, provider, child) {
        // عرض حالة التحميلات النشطة
        return const Center(child: Text('تبويب التحميلات قيد التطوير'));
      },
    );
  }

  /// 📋 حالة فارغة
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ).animate().scale(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
        ],
      ),
    );
  }

  /// 🎯 تحديد نموذج
  void _selectModel(OllamaModel model) {
    Provider.of<OllamaProvider>(context, listen: false).selectModel(model);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحديد النموذج: ${model.displayName}')),
    );
  }

  /// 📥 تحميل نموذج
  void _downloadModel(OllamaModel model) {
    Provider.of<OllamaProvider>(context, listen: false).pullModel(model.name);
  }

  /// 🗑️ حذف نموذج
  void _deleteModel(OllamaModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف النموذج'),
        content: Text('هل أنت متأكد من حذف النموذج "${model.displayName}"؟'),
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
              ).deleteModel(model.name);
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

  /// ➕ عرض حوار إضافة نموذج
  void _showAddModelDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة نموذج جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'اسم النموذج',
                hintText: 'مثال: llama2:7b',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'سيتم تحميل النموذج من مستودع Ollama الرسمي',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final modelName = controller.text.trim();
              if (modelName.isNotEmpty) {
                Provider.of<OllamaProvider>(
                  context,
                  listen: false,
                ).pullModel(modelName);
                Navigator.pop(context);
              }
            },
            child: const Text('تحميل'),
          ),
        ],
      ),
    );
  }

  /// 📋 معالجة إجراءات القائمة
  void _handleMenuAction(String action) {
    switch (action) {
      case 'add_model':
        _showAddModelDialog();
        break;
      case 'import_model':
        // استيراد نموذج من ملف
        break;
    }
  }
}

/// 🎴 بطاقة النموذج
class ModelCard extends StatelessWidget {
  final OllamaModel model;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const ModelCard({
    super.key,
    required this.model,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(
                      model.colorCode,
                    ).withValues(alpha: 0.2),
                    child: Icon(Icons.smart_toy, color: Color(model.colorCode)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (model.tag != null)
                          Text(
                            model.tag!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      model.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: model.isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          onDelete?.call();
                          break;
                        case 'download':
                          onDownload?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (onDownload != null)
                        const PopupMenuItem(
                          value: 'download',
                          child: ListTile(
                            leading: Icon(Icons.download),
                            title: Text('تحميل'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text(
                              'حذف',
                              style: TextStyle(color: Colors.red),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (model.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  model.description!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(theme, Icons.storage, model.formattedSize),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    theme,
                    Icons.access_time,
                    'استخدم ${model.usageCount} مرة',
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: model.isDownloaded
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      model.isDownloaded ? 'محمل' : 'غير محمل',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: model.isDownloaded
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

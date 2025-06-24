// ⚙️ شاشة الإعدادات - إدارة جميع إعدادات التطبيق

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../providers/ollama_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../constants/app_constants.dart';

/// ⚙️ شاشة الإعدادات الرئيسية
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الإعدادات', showBackButton: false),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSection(context, 'المظهر والواجهة', Icons.palette_outlined, [
            _buildThemeSettings(),
            _buildFontSettings(),
            _buildAnimationSettings(),
          ]),
          _buildSection(context, 'الاتصال والخادم', Icons.cloud_outlined, [
            _buildConnectionSettings(),
            _buildModelSettings(),
          ]),
          _buildSection(context, 'الصوت والوسائط', Icons.volume_up_outlined, [
            _buildAudioSettings(),
            _buildMediaSettings(),
          ]),
          _buildSection(context, 'الأمان والخصوصية', Icons.security_outlined, [
            _buildSecuritySettings(),
            _buildPrivacySettings(),
          ]),
          _buildSection(
            context,
            'النسخ الاحتياطي والتصدير',
            Icons.backup_outlined,
            [_buildBackupSettings(), _buildExportSettings()],
          ),
          _buildSection(context, 'حول التطبيق', Icons.info_outlined, [
            _buildAboutSettings(),
          ]),
        ],
      ),
    );
  }

  /// 📋 بناء قسم الإعدادات
  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(child: Column(children: children)),
        ],
      ),
    ).animate().slideX(
      begin: 0.3,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }

  /// 🎨 إعدادات الثيم
  Widget _buildThemeSettings() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('وضع الثيم'),
              subtitle: Text(
                _getThemeModeText(themeProvider.appSettings.themeMode),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeModeDialog(themeProvider),
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: const Icon(Icons.color_lens_outlined),
              title: const Text('الألوان الديناميكية'),
              subtitle: const Text('استخدام ألوان النظام'),
              value: themeProvider.appSettings.useDynamicColors,
              onChanged: themeProvider.supportsDynamicColor
                  ? (value) => themeProvider.toggleDynamicColors()
                  : null,
            ),
          ],
        );
      },
    );
  }

  /// 🔤 إعدادات الخط
  Widget _buildFontSettings() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.font_download_outlined),
              title: const Text('عائلة الخط'),
              subtitle: Text(themeProvider.appSettings.fontFamily),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFontFamilyDialog(themeProvider),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('حجم الخط'),
              subtitle: Slider(
                value: themeProvider.appSettings.fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: '${themeProvider.appSettings.fontSize.round()}',
                onChanged: (value) => themeProvider.updateFontSize(value),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🎭 إعدادات الأنيميشن
  Widget _buildAnimationSettings() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.animation),
              title: const Text('تفعيل الأنيميشن'),
              subtitle: const Text('تأثيرات بصرية متحركة'),
              value: themeProvider.appSettings.enableAnimations,
              onChanged: (value) {
                final newSettings = themeProvider.appSettings.copyWith(
                  enableAnimations: value,
                );
                themeProvider.updateAppSettings(newSettings);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('الاهتزاز التفاعلي'),
              subtitle: const Text('اهتزاز عند اللمس'),
              value: themeProvider.appSettings.enableHapticFeedback,
              onChanged: (value) {
                final newSettings = themeProvider.appSettings.copyWith(
                  enableHapticFeedback: value,
                );
                themeProvider.updateAppSettings(newSettings);
              },
            ),
          ],
        );
      },
    );
  }

  /// 🌐 إعدادات الاتصال
  Widget _buildConnectionSettings() {
    return Consumer<OllamaProvider>(
      builder: (context, provider, child) {
        return ListTile(
          leading: const Icon(Icons.dns_outlined),
          title: const Text('إعدادات الخادم'),
          subtitle: Text(provider.connectionSettings.serverUrl),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showConnectionDialog(provider),
        );
      },
    );
  }

  /// 🤖 إعدادات النموذج
  Widget _buildModelSettings() {
    return Consumer<OllamaProvider>(
      builder: (context, provider, child) {
        return ListTile(
          leading: const Icon(Icons.tune_outlined),
          title: const Text('معاملات النموذج'),
          subtitle: const Text('درجة الحرارة والمعاملات الأخرى'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showModelParametersDialog(provider),
        );
      },
    );
  }

  /// 🔊 إعدادات الصوت
  Widget _buildAudioSettings() {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.record_voice_over),
          title: const Text('تحويل النص إلى كلام'),
          subtitle: const Text('قراءة الردود بصوت عالٍ'),
          value: false, // من قاعدة البيانات
          onChanged: (value) {
            // تحديث الإعدادات
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.mic),
          title: const Text('تحويل الكلام إلى نص'),
          subtitle: const Text('إدخال الرسائل بالصوت'),
          value: false, // من قاعدة البيانات
          onChanged: (value) {
            // تحديث الإعدادات
          },
        ),
      ],
    );
  }

  /// 📱 إعدادات الوسائط
  Widget _buildMediaSettings() {
    return ListTile(
      leading: const Icon(Icons.perm_media_outlined),
      title: const Text('إعدادات الوسائط'),
      subtitle: const Text('جودة الصور والفيديو'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // عرض إعدادات الوسائط
      },
    );
  }

  /// 🔐 إعدادات الأمان
  Widget _buildSecuritySettings() {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.lock_outlined),
          title: const Text('قفل التطبيق'),
          subtitle: const Text('حماية التطبيق برقم سري'),
          value: false, // من قاعدة البيانات
          onChanged: (value) {
            // تحديث الإعدادات
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('البصمة الحيوية'),
          subtitle: const Text('فتح التطبيق بالبصمة'),
          value: false, // من قاعدة البيانات
          onChanged: (value) {
            // تحديث الإعدادات
          },
        ),
      ],
    );
  }

  /// 🔒 إعدادات الخصوصية
  Widget _buildPrivacySettings() {
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.visibility_off_outlined),
          title: const Text('الوضع الخفي'),
          subtitle: const Text('عدم حفظ المحادثات'),
          value: false, // من قاعدة البيانات
          onChanged: (value) {
            // تحديث الإعدادات
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.auto_delete_outlined),
          title: const Text('حذف البيانات القديمة'),
          subtitle: const Text('حذف المحادثات تلقائياً'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // عرض إعدادات الحذف التلقائي
          },
        ),
      ],
    );
  }

  /// 💾 إعدادات النسخ الاحتياطي
  Widget _buildBackupSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.backup_outlined),
          title: const Text('إنشاء نسخة احتياطية'),
          subtitle: const Text('حفظ جميع البيانات'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // إنشاء نسخة احتياطية
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.restore_outlined),
          title: const Text('استعادة النسخة الاحتياطية'),
          subtitle: const Text('استيراد البيانات المحفوظة'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // استعادة النسخة الاحتياطية
          },
        ),
      ],
    );
  }

  /// 📤 إعدادات التصدير
  Widget _buildExportSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: const Text('تصدير المحادثات'),
          subtitle: const Text('حفظ كملف JSON أو PDF'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // تصدير المحادثات
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.share_outlined),
          title: const Text('مشاركة الإعدادات'),
          subtitle: const Text('مشاركة إعدادات التطبيق'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // مشاركة الإعدادات
          },
        ),
      ],
    );
  }

  /// ℹ️ معلومات التطبيق
  Widget _buildAboutSettings() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outlined),
          title: const Text('حول التطبيق'),
          subtitle: Text('الإصدار ${AppConstants.appVersion}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // عرض معلومات التطبيق
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('المساعدة والدعم'),
          subtitle: const Text('الأسئلة الشائعة والدعم الفني'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // عرض المساعدة
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.star_outline),
          title: const Text('تقييم التطبيق'),
          subtitle: const Text('ساعدنا في تحسين التطبيق'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // فتح صفحة التقييم
          },
        ),
      ],
    );
  }

  /// 🎨 عرض حوار وضع الثيم
  void _showThemeModeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('وضع الثيم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeModeText(mode)),
              value: mode,
              groupValue: themeProvider.appSettings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  final newSettings = themeProvider.appSettings.copyWith(
                    themeMode: value,
                  );
                  themeProvider.updateAppSettings(newSettings);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 🔤 عرض حوار عائلة الخط
  void _showFontFamilyDialog(ThemeProvider themeProvider) {
    final fonts = ['Cairo', 'Roboto', 'Noto Sans Arabic'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عائلة الخط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: fonts.map((font) {
            return RadioListTile<String>(
              title: Text(font, style: TextStyle(fontFamily: font)),
              value: font,
              groupValue: themeProvider.appSettings.fontFamily,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.updateFontFamily(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 🌐 عرض حوار إعدادات الاتصال
  void _showConnectionDialog(OllamaProvider provider) {
    // عرض حوار إعدادات الاتصال
  }

  /// 🤖 عرض حوار معاملات النموذج
  void _showModelParametersDialog(OllamaProvider provider) {
    // عرض حوار معاملات النموذج
  }

  /// 📝 الحصول على نص وضع الثيم
  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.system:
        return 'تلقائي';
    }
  }
}

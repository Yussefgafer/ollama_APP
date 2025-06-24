// 🎯 شريط التطبيق المخصص - شريط علوي أنيق ومتقدم

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🎯 شريط التطبيق المخصص
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      elevation: elevation,
      scrolledUnderElevation: 1,
      leading:
          leading ??
          (canPop && showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: theme.colorScheme.surface,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// 🎨 شريط تطبيق متدرج
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final List<Color> gradientColors;
  final double elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const GradientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    required this.gradientColors,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: titleWidget ?? (title != null ? Text(title!) : null),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: elevation,
        leading:
            leading ??
            (canPop && showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                  )
                : null),
        actions: actions?.map((action) {
          if (action is IconButton) {
            return IconButton(
              icon: action.icon,
              onPressed: action.onPressed,
              color: Colors.white,
            );
          }
          return action;
        }).toList(),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 🔍 شريط تطبيق مع بحث
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final String? searchHint;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchClosed;
  final List<Widget>? actions;
  final bool showSearchButton;

  const SearchAppBar({
    super.key,
    this.title,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchClosed,
    this.actions,
    this.showSearchButton = true,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  late TextEditingController _searchController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _animationController.forward();
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
    });
    _animationController.reverse();
    _searchController.clear();
    widget.onSearchChanged?.call('');
    widget.onSearchClosed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? 'البحث...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                onChanged: widget.onSearchChanged,
              )
            : Text(widget.title ?? ''),
      ),
      actions: [
        if (widget.showSearchButton)
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ).animate(target: _isSearching ? 1 : 0).rotate(),
        ...?widget.actions,
      ],
    );
  }
}

/// 📊 شريط تطبيق مع إحصائيات
class StatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Map<String, dynamic> stats;
  final List<Widget>? actions;

  const StatsAppBar({
    super.key,
    required this.title,
    required this.stats,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (stats.isNotEmpty)
            Text(
              _buildStatsText(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
      actions: actions,
    );
  }

  String _buildStatsText() {
    final List<String> statsList = [];

    stats.forEach((key, value) {
      switch (key) {
        case 'conversations':
          statsList.add('$value محادثة');
          break;
        case 'messages':
          statsList.add('$value رسالة');
          break;
        case 'models':
          statsList.add('$value نموذج');
          break;
        default:
          statsList.add('$key: $value');
      }
    });

    return statsList.join(' • ');
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

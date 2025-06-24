// ⌨️ مؤشر الكتابة - عرض حالة الكتابة بتأثيرات أنيقة

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ⌨️ مؤشر الكتابة الرئيسي
class TypingIndicator extends StatefulWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? dotColor;
  final double? dotSize;

  const TypingIndicator({
    super.key,
    this.message,
    this.backgroundColor,
    this.dotColor,
    this.dotSize,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _dotAnimations[index],
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                  child: Transform.scale(
                    scale: 0.5 + (_dotAnimations[index].value * 0.5),
                    child: Container(
                      width: widget.dotSize ?? 8,
                      height: widget.dotSize ?? 8,
                      decoration: BoxDecoration(
                        color: (widget.dotColor ?? theme.colorScheme.primary)
                            .withValues(
                              alpha: 0.3 + (_dotAnimations[index].value * 0.7),
                            ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          if (widget.message != null) ...[
            const SizedBox(width: 8),
            Text(
              widget.message!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.3);
  }
}

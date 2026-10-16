import 'package:flutter/material.dart';

/// Retro Pixel Card with zero border-radius, hard 2px black border, and solid 3px offset shadow
class PixelCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final Color shadowColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const PixelCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor = const Color(0xFF000000),
    this.borderWidth = 2.0,
    this.shadowOffset = 3.0,
    this.shadowColor = const Color(0xFF000000),
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? Theme.of(context).cardColor;

    final container = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadowOffset > 0
            ? [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(shadowOffset, shadowOffset),
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

/// Retro Pixel Button with mechanical press offset animation
class PixelButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final bool isSmall;

  const PixelButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor = const Color(0xFF000000),
    this.borderWidth = 2.0,
    this.shadowOffset = 3.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.isSmall = false,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final effectiveBg = !enabled
        ? Colors.grey.shade400
        : (widget.backgroundColor ?? Theme.of(context).colorScheme.primary);

    final effectivePadding = widget.isSmall
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
        : widget.padding;

    final effectiveTextColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
      child: Transform.translate(
        offset: _isPressed ? Offset(widget.shadowOffset, widget.shadowOffset) : Offset.zero,
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: widget.borderColor, width: widget.borderWidth),
            boxShadow: (!_isPressed && widget.shadowOffset > 0)
                ? [
                    BoxShadow(
                      color: widget.borderColor,
                      offset: Offset(widget.shadowOffset, widget.shadowOffset),
                      blurRadius: 0,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              fontSize: widget.isSmall ? 11 : 13,
              color: effectiveTextColor,
              letterSpacing: 0.5,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Pixel Badge / Tag
class PixelBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;

  const PixelBadge({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFFA520F),
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              fontSize: 10,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pixel Stepped Progress Bar (Like HP/EXP in 8-bit games)
class PixelProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double height;
  final String? label;

  const PixelProgressBar({
    super.key,
    required this.progress,
    this.progressColor = const Color(0xFF16A34A),
    this.backgroundColor = const Color(0xFFE2E8F0),
    this.height = 16.0,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: clamped,
            child: Container(
              color: progressColor,
            ),
          ),
          if (label != null)
            Center(
              child: Text(
                label!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

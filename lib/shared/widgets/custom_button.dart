import 'package:cltvspj/shared/theme/typography_extension.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final double? maxWidth;
  final double? minWidth;
  final double? height;
  final bool fullWidth;
  final bool animatedGradient;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
    this.maxWidth,
    this.minWidth,
    this.height = 30,
    this.fullWidth = false,
    this.animatedGradient = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animatedGradient) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat();
    }
  }

  @override
  void dispose() {
    if (widget.animatedGradient) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Text(widget.text, style: context.bodySmallBold);

    final button = widget.animatedGradient
        ? AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return GestureDetector(
                onTap: widget.onPressed,
                child: Container(
                  width: widget.fullWidth ? double.infinity : widget.maxWidth,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.8),
                        widget.color,
                      ],
                      begin: Alignment(-1 + 2 * _controller.value, 0),
                      end: Alignment(_controller.value, 0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(child: child),
                ),
              );
            },
          )
        : FilledButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(widget.color),
              minimumSize: WidgetStateProperty.all(
                Size(widget.minWidth ?? 0, widget.height ?? 30),
              ),
              maximumSize: WidgetStateProperty.all(
                Size(widget.maxWidth ?? double.infinity, widget.height ?? 30),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            child: child,
          );

    if (widget.fullWidth) {
      return SizedBox(
        width: double.infinity,
        height: widget.height,
        child: button,
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
          minWidth: widget.minWidth ?? 0,
          minHeight: widget.height ?? 0,
        ),
        child: SizedBox(
          width: widget.maxWidth,
          height: widget.height,
          child: button,
        ),
      ),
    );
  }
}
